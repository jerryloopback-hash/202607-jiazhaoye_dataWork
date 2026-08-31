# -*- coding: utf-8 -*-
"""将三份已重建 DDL 转换为 SR 格式并生成一个可执行 SQL。"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

OUT_DIR = Path(__file__).resolve().parent
SOURCES = [
    ("jianengliang", OUT_DIR / "jianengliang.sql"),
    ("training", OUT_DIR / "training.sql"),
    ("vmdb", OUT_DIR / "vmdb.sql"),
]
TARGET = OUT_DIR / "文体_ods_建表.sql"
PREFIX = "ods_wenti_"
CREATE_RE = re.compile(
    r"CREATE TABLE `(?P<name>[^`]+)`\s*\((?P<body>.*?)\)\s*(?P<opts>ENGINE[^;]*);",
    re.DOTALL,
)
COMMENT_RE = re.compile(r"\s+COMMENT\s*=\s*'(?P<comment>(?:[^'\\]|\\.)*)'", re.IGNORECASE)
OPTION_RE = {
    "engine": re.compile(r"\bENGINE\s*=\s*(?P<value>\w+)", re.IGNORECASE),
    "auto_increment": re.compile(r"\bAUTO_INCREMENT\s*=\s*(?P<value>\d+)", re.IGNORECASE),
    "row_format": re.compile(r"\bROW_FORMAT\s*=\s*(?P<value>\w+)", re.IGNORECASE),
}
FIELD_CHARSET_RE = re.compile(r"\s+CHARACTER SET\s*(?:=\s*)?\w+", re.IGNORECASE)
FIELD_COLLATE_RE = re.compile(r"\s+COLLATE\s*(?:=\s*)?\w+", re.IGNORECASE)
FOREIGN_RE = re.compile(r"\b(?:FOREIGN KEY|REFERENCES)\b", re.IGNORECASE)


def unescape_sql(value: str) -> str:
    return value.replace("\\'", "'").replace("\\\\", "\\")


def quote_sql(value: str) -> str:
    return value.replace("\\", "\\\\").replace("'", "\\'")


def option_value(options: str, key: str) -> str | None:
    match = OPTION_RE[key].search(options)
    return match.group("value") if match else None


def table_comment(options: str) -> str:
    match = COMMENT_RE.search(options)
    return unescape_sql(match.group("comment")) if match else ""


def sr_name(domain: str, current_name: str) -> str:
    if not current_name.startswith(PREFIX):
        raise ValueError(f"Unexpected table name: {current_name}")
    return f"{PREFIX}{domain}_{current_name[len(PREFIX):]}"


def clean_body(body: str) -> str:
    """Remove only explicit per-column encoding options; leave all semantics intact."""
    result = []
    for line in body.splitlines():
        line = line.strip()
        if not line:
            continue
        if line.startswith("`"):
            line = FIELD_CHARSET_RE.sub("", line)
            line = FIELD_COLLATE_RE.sub("", line)
            line = re.sub(r" {2,}", " ", line)
        line = "  " + line
        result.append(line)
    return "\r\n".join(result)


def normalized_model(name: str, body: str, options: str) -> dict:
    """Fingerprint required schema semantics, excluding allowed names/encodings/comments formatting."""
    normalized_fields = []
    indexes = []
    for line in body.splitlines():
        stripped = line.strip().rstrip(",")
        if not stripped:
            continue
        if stripped.startswith("`"):
            stripped = FIELD_CHARSET_RE.sub("", stripped)
            stripped = FIELD_COLLATE_RE.sub("", stripped)
            normalized_fields.append(re.sub(r"\s+", " ", stripped).strip())
        else:
            indexes.append(re.sub(r"\s+", " ", stripped).strip())
    return {
        "name_suffix": name[len(PREFIX):] if name.startswith(PREFIX) else name,
        "fields": normalized_fields,
        "indexes": indexes,
        "engine": option_value(options, "engine"),
        "auto_increment": option_value(options, "auto_increment"),
        "row_format": (option_value(options, "row_format") or "").upper(),
        "comment": table_comment(options),
    }


def render_table(domain: str, match: re.Match) -> tuple[str, dict]:
    old_name = match.group("name")
    body = match.group("body")
    options = match.group("opts")
    if FOREIGN_RE.search(body) or FOREIGN_RE.search(options):
        raise ValueError(f"{domain}.{old_name}: foreign key/reference found; requires explicit rewrite")
    new_name = sr_name(domain, old_name)
    comment = table_comment(options)
    engine = option_value(options, "engine") or "InnoDB"
    auto_increment = option_value(options, "auto_increment")
    row_format = option_value(options, "row_format")
    body = clean_body(body)
    lines = [
        "-- ----------------------------",
        f"-- {new_name}" + (f"   {comment}" if comment else ""),
        "-- ----------------------------",
        f"DROP TABLE IF EXISTS `{new_name}`;",
        f"CREATE TABLE `{new_name}`  (" + "\r\n" + body + "\r\n) " + f"ENGINE = {engine}",
    ]
    if auto_increment is not None:
        lines.append(f"  AUTO_INCREMENT = {auto_increment}")
    lines.extend([
        "  DEFAULT CHARACTER SET = utf8mb4",
        "  COLLATE = utf8mb4_unicode_ci",
    ])
    if comment:
        lines.append(f"  COMMENT = '{quote_sql(comment)}'")
    if row_format is not None:
        lines.append(f"  ROW_FORMAT = {row_format.upper()};")
    else:
        lines[-1] += ";"
    return "\r\n".join(lines), normalized_model(old_name, match.group("body"), options)


def strict_utf8_crlf(path: Path) -> str:
    raw = path.read_bytes()
    if raw.startswith(b"\xef\xbb\xbf"):
        raise ValueError(f"{path.name}: must not contain UTF-8 BOM")
    if b"\n" in raw.replace(b"\r\n", b""):
        raise ValueError(f"{path.name}: source must use CRLF-only line endings")
    return raw.decode("utf-8")


def main():
    chunks = [
        "/* 文体 ODS 建表脚本（SR 格式） */",
        "SET NAMES utf8mb4;",
        "SET FOREIGN_KEY_CHECKS = 0;",
        "",
    ]
    models = []
    final_names = []
    source_counts = {}
    for domain, path in SOURCES:
        text = strict_utf8_crlf(path)
        matches = list(CREATE_RE.finditer(text))
        source_counts[domain] = len(matches)
        chunks.append(f"-- ============================================================")
        chunks.append(f"-- 来源数据库：{domain}")
        chunks.append(f"-- ============================================================")
        chunks.append("")
        for match in matches:
            rendered, model = render_table(domain, match)
            new_name = sr_name(domain, match.group("name"))
            final_names.append(new_name)
            models.append((domain, new_name, model))
            chunks.append(rendered)
            chunks.append("")
    chunks.append("SET FOREIGN_KEY_CHECKS = 1;")
    output = "\r\n".join(chunks) + "\r\n"

    if len(final_names) != 100:
        raise ValueError(f"Expected 100 source-qualified tables, got {len(final_names)}")
    if len(final_names) != len(set(final_names)):
        raise ValueError("Final table names are not unique")
    if len(re.findall(r"CREATE TABLE `", output)) != 100 or len(re.findall(r"DROP TABLE IF EXISTS `", output)) != 100:
        raise ValueError("CREATE/DROP count validation failed")
    if re.search(r"\bCHARACTER SET\b(?!\s*=\s*utf8mb4)", output, re.IGNORECASE):
        raise ValueError("Unexpected CHARACTER SET clause remained in output")
    if re.search(r"\bCOLLATE\b(?!\s*=\s*utf8mb4_unicode_ci)", output, re.IGNORECASE):
        raise ValueError("Unexpected COLLATE clause remained in output")
    if output.count("DEFAULT CHARACTER SET = utf8mb4") != 100:
        raise ValueError("Missing table-level utf8mb4 defaults")
    if output.count("COLLATE = utf8mb4_unicode_ci") != 100:
        raise ValueError("Missing table-level unicode collations")

    TARGET.write_bytes(output.encode("utf-8"))
    report = {
        "target": str(TARGET),
        "source_counts": source_counts,
        "final_tables": len(final_names),
        "distinct_final_tables": len(set(final_names)),
        "sha256": hashlib.sha256(output.encode("utf-8")).hexdigest(),
        "models": models,
    }
    report_path = OUT_DIR / "文体_ods_建表_校验清单.json"
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8", newline="\r\n")
    print(json.dumps({key: value for key, value in report.items() if key != "models"}, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    main()
