# -*- coding: utf-8 -*-
"""仅用于本次三份重建 DDL 的注释补全与 utf8mb4 标准化。"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import re
import zipfile
from collections import Counter, defaultdict
from pathlib import Path
from xml.etree import ElementTree as ET

ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = Path(__file__).resolve().parent
WORKBOOK = ROOT / "重建数据库" / "文体_数据源清单（测试）.xlsx"
FILES = {
    "jianengliang": OUT_DIR / "jianengliang.sql",
    "training": OUT_DIR / "training.sql",
    "vmdb": OUT_DIR / "vmdb.sql",
}
PREFIX = "ods_wenti_"
XML_NS = {
    "main": "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
    "rel": "http://schemas.openxmlformats.org/package/2006/relationships",
    "docrel": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
}

# Prefer source-specific sheets. The broad catalog is fallback only.
DOMAIN_FIELD_SHEETS = {
    "jianengliang": ["jianengliang_活动所有表及字段"],
    "training": ["training_所有数据表及字段"],
    "vmdb": ["vmdb_所有数据表及字段"],
}
DOMAIN_TABLE_SHEETS = {
    "jianengliang": [],
    "training": ["training_所有数据表"],
    "vmdb": ["vmdb_所有数据表"],
}
FALLBACK_FIELD_SHEETS = ["所有数据表及数据字段"]
FALLBACK_TABLE_SHEETS = ["所有数据表"]
PLACEHOLDERS = {"", "无", "待确认", "(推测,待确认)", "（推测，待确认）", "-", "--", "n/a", "na"}

CREATE_RE = re.compile(
    r"CREATE TABLE `(?P<name>[^`]+)`\s*\((?P<body>.*?)\)\s*(?P<opts>ENGINE[^;]*);",
    re.DOTALL,
)
FIELD_RE = re.compile(r"^(?P<indent>\s*)`(?P<name>[^`]+)`(?P<rest>[^\r\n]*)(?P<eol>\r?)$", re.MULTILINE)
COMMENT_RE = re.compile(r"\s+COMMENT\s+'(?:[^'\\]|\\.)*'", re.IGNORECASE)
TABLE_COMMENT_RE = re.compile(r"\s+COMMENT\s*=\s*'(?:[^'\\]|\\.)*'", re.IGNORECASE)
INDEX_COLUMN_RE = re.compile(r"(?:PRIMARY KEY|UNIQUE INDEX|INDEX)\s+[^\(]*\((?P<columns>[^)]*)\)", re.IGNORECASE)
TYPE_RE = re.compile(r"^\s*(?P<type>varchar|char)\s*\(\s*(?P<len>\d+)\s*\)", re.IGNORECASE)


def clean(value: str | None) -> str:
    if value is None:
        return ""
    return value.replace(" ", " ").replace("\x7f", "").strip()


def usable(value: str | None) -> bool:
    normalized = clean(value)
    return normalized.lower() not in PLACEHOLDERS


def sql_quote(value: str) -> str:
    return value.replace("\\", "\\\\").replace("'", "\\'")


def col_letter(ref: str) -> str:
    return re.match(r"[A-Z]+", ref).group(0)


def read_xlsx(path: Path) -> dict[str, list[dict[str, str]]]:
    with zipfile.ZipFile(path) as zf:
        shared = []
        if "xl/sharedStrings.xml" in zf.namelist():
            root = ET.fromstring(zf.read("xl/sharedStrings.xml"))
            for si in root.findall("main:si", XML_NS):
                shared.append("".join(t.text or "" for t in si.iterfind(".//main:t", XML_NS)))
        wb = ET.fromstring(zf.read("xl/workbook.xml"))
        rels = ET.fromstring(zf.read("xl/_rels/workbook.xml.rels"))
        rel_map = {r.attrib["Id"]: r.attrib["Target"] for r in rels.findall("rel:Relationship", XML_NS)}
        sheets = {}
        for sheet in wb.findall("main:sheets/main:sheet", XML_NS):
            name = sheet.attrib["name"]
            rid = sheet.attrib["{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id"]
            target = rel_map[rid]
            sheet_path = "xl/" + target.lstrip("/") if not target.startswith("/") else target.lstrip("/")
            if not sheet_path.startswith("xl/"):
                sheet_path = "xl/" + sheet_path
            root = ET.fromstring(zf.read(sheet_path))
            rows = []
            for row in root.findall(".//main:sheetData/main:row", XML_NS):
                values = {}
                for cell in row.findall("main:c", XML_NS):
                    ref = cell.attrib.get("r", "")
                    letter = col_letter(ref)
                    ctype = cell.attrib.get("t")
                    value_node = cell.find("main:v", XML_NS)
                    if ctype == "inlineStr":
                        value = "".join(t.text or "" for t in cell.findall(".//main:t", XML_NS))
                    elif value_node is None:
                        value = ""
                    else:
                        raw = value_node.text or ""
                        value = shared[int(raw)] if ctype == "s" and raw.isdigit() else raw
                    values[letter] = clean(value)
                if values:
                    rows.append(values)
            if rows:
                header = rows[0]
                sheets[name] = [
                    {header.get(letter, letter): value for letter, value in row.items()}
                    for row in rows[1:]
                ]
        return sheets


def first_value(row: dict[str, str], labels: list[str]) -> str:
    for label in labels:
        for key, value in row.items():
            if clean(key) == label and usable(value):
                return clean(value)
    return ""


def build_catalog(sheets: dict[str, list[dict[str, str]]]):
    field_maps = defaultdict(lambda: defaultdict(list))
    table_maps = defaultdict(lambda: defaultdict(list))

    def ingest_fields(domain: str, sheet_names: list[str], tier: str):
        for sheet_name in sheet_names:
            for row_no, row in enumerate(sheets.get(sheet_name, []), 2):
                table = first_value(row, ["数据表名称", "表名"])
                field = first_value(row, ["字段名称", "字段名"])
                comment = first_value(row, ["字段中文称", "字段中文名称", "中文字段名", "字段说明"])
                if table and field and usable(comment):
                    field_maps[domain][(table, field)].append((tier, sheet_name, row_no, comment))

    def ingest_tables(domain: str, sheet_names: list[str], tier: str):
        for sheet_name in sheet_names:
            for row_no, row in enumerate(sheets.get(sheet_name, []), 2):
                table = first_value(row, ["表名", "数据表名称"])
                comment = first_value(row, ["中文表名", "数据表中文名称", "表中文名称", "表说明"])
                if table and usable(comment):
                    table_maps[domain][table].append((tier, sheet_name, row_no, comment))

    for domain in FILES:
        ingest_fields(domain, DOMAIN_FIELD_SHEETS[domain], "domain")
        ingest_tables(domain, DOMAIN_TABLE_SHEETS[domain], "domain")
        ingest_fields(domain, FALLBACK_FIELD_SHEETS, "fallback")
        ingest_tables(domain, FALLBACK_TABLE_SHEETS, "fallback")
    return field_maps, table_maps


def select_candidate(candidates: list[tuple[str, str, int, str]]):
    """Prefer domain candidates; only accept one distinct nonempty comment."""
    domain = [c for c in candidates if c[0] == "domain"]
    pool = domain or candidates
    distinct = {c[3] for c in pool}
    if len(distinct) == 1:
        return pool[0], None
    return None, "ambiguous"


def comment_exists(text: str) -> bool:
    return COMMENT_RE.search(text) is not None


def parse_model(text: str):
    tables = []
    for match in CREATE_RE.finditer(text):
        fields = []
        for line in match.group("body").splitlines():
            stripped = line.strip()
            if stripped.startswith("`"):
                name = stripped.split("`", 2)[1]
                fields.append((name, stripped))
        tables.append({"name": match.group("name"), "fields": fields, "opts": match.group("opts")})
    return tables


def fingerprint(text: str):
    """Fingerprint required schema shape with field-level tokens independent of comments/charset."""
    tables = []
    for match in CREATE_RE.finditer(text):
        fields = []
        keys = []
        for line in match.group("body").splitlines():
            stripped = line.strip().rstrip(",")
            if not stripped:
                continue
            if stripped.startswith("`"):
                name = stripped.split("`", 2)[1]
                rest = stripped.split("`", 2)[2]
                rest = COMMENT_RE.sub("", rest)
                rest = re.sub(r"\s+CHARACTER SET\s+utf8(?:mb4)?", "", rest, flags=re.IGNORECASE)
                rest = re.sub(r"\s+COLLATE\s+utf8(?:mb4)?_[a-z0-9_]+", "", rest, flags=re.IGNORECASE)
                fields.append((name, re.sub(r"\s+", " ", rest).strip()))
            elif stripped.upper().startswith(("PRIMARY KEY", "UNIQUE INDEX", "INDEX", "CONSTRAINT", "FOREIGN KEY")):
                keys.append(re.sub(r"\s+", " ", stripped).strip())
        tables.append((match.group("name"), fields, keys))
    return hashlib.sha256(json.dumps(tables, ensure_ascii=False, separators=(",", ":")).encode("utf-8")).hexdigest()


def transform_file(domain: str, source: str, field_maps, table_maps):
    report = Counter()
    unresolved = []
    ambiguous = []

    def transform_table(match: re.Match):
        name, body, opts = match.group("name"), match.group("body"), match.group("opts")
        source_name = name[len(PREFIX):] if name.startswith(PREFIX) else name

        # Fill blank field comments only. Existing comments are deliberately untouched.
        def transform_line(line_match: re.Match):
            line = line_match.group(0)
            field = line_match.group("name")
            if field == "extract_time" or comment_exists(line):
                return line
            candidate, reason = select_candidate(field_maps[domain].get((source_name, field), []))
            if candidate:
                report["field_comments_added"] += 1
                suffix_match = re.search(r"(?P<comma>,?)(?P<eol>\r?)$", line)
                suffix = suffix_match.group("comma")
                eol = suffix_match.group("eol")
                before = line[:suffix_match.start()]
                return before + " COMMENT '" + sql_quote(candidate[3]) + "'" + suffix + eol
            if reason == "ambiguous":
                ambiguous.append(("field", name, field))
            else:
                unresolved.append(("field", name, field))
            return line

        new_body = FIELD_RE.sub(transform_line, body)
        # Fill a blank table comment only; preserve any existing non-empty table comment.
        if not TABLE_COMMENT_RE.search(opts):
            candidate, reason = select_candidate(table_maps[domain].get(source_name, []))
            if candidate:
                table_comment = " COMMENT = '" + sql_quote(candidate[3]) + "'"
                # Put the table comment before ROW_FORMAT when present, otherwise before statement semicolon.
                row_format = re.search(r"\s+ROW_FORMAT\s*=\s*\w+", opts, re.IGNORECASE)
                if row_format:
                    opts = opts[:row_format.start()] + table_comment + opts[row_format.start():]
                else:
                    opts += table_comment
                report["table_comments_added"] += 1
            elif reason == "ambiguous":
                ambiguous.append(("table", name, ""))
            else:
                unresolved.append(("table", name, ""))

        # Charset standardization. Preserve collation family / comparison behavior.
        new_body = re.sub(r"\bCHARACTER SET\s+utf8\b", "CHARACTER SET utf8mb4", new_body, flags=re.IGNORECASE)
        new_body = re.sub(r"\bCOLLATE\s+utf8_", "COLLATE utf8mb4_", new_body, flags=re.IGNORECASE)
        opts = re.sub(r"\bCHARACTER SET\s*=\s*utf8\b", "CHARACTER SET = utf8mb4", opts, flags=re.IGNORECASE)
        opts = re.sub(r"\bCOLLATE\s*=\s*utf8_", "COLLATE = utf8mb4_", opts, flags=re.IGNORECASE)
        return "CREATE TABLE `" + name + "`  (" + new_body + ") " + opts + ";"

    output = CREATE_RE.sub(transform_table, source)
    return output, report, unresolved, ambiguous


def indexed_varchar_risks(text: str):
    risks = []
    for table in parse_model(text):
        fields = {}
        for field_name, definition in table["fields"]:
            type_match = TYPE_RE.match(definition.split("`", 2)[2])
            if type_match:
                fields[field_name] = int(type_match.group("len"))
        body = "\n".join(line for _, line in table["fields"])
        # Use original full CREATE body from source model is unnecessary; find index lines in surrounding table via reparse below.
    for match in CREATE_RE.finditer(text):
        name = match.group("name")
        definitions = {}
        for line in match.group("body").splitlines():
            fm = re.match(r"\s*`([^`]+)`\s+(.*)", line)
            if fm:
                tm = TYPE_RE.match(fm.group(2))
                if tm:
                    definitions[fm.group(1)] = int(tm.group("len"))
        for line in match.group("body").splitlines():
            im = INDEX_COLUMN_RE.search(line)
            if not im:
                continue
            total = 0
            chars = []
            for token in im.group("columns").split(","):
                col = token.strip().strip("`").split("(")[0].strip()
                if col in definitions:
                    total += definitions[col] * 4
                    chars.append((col, definitions[col]))
            if total > 767 and chars:
                risks.append((name, line.strip(), total, chars))
    return risks


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    sheets = read_xlsx(WORKBOOK)
    field_maps, table_maps = build_catalog(sheets)
    all_reports = {}
    for domain, path in FILES.items():
        raw = path.read_bytes()
        if raw.startswith(b"\xef\xbb\xbf"):
            raise ValueError(f"{path.name}: unexpected UTF-8 BOM")
        if b"\n" in raw.replace(b"\r\n", b""):
            raise ValueError(f"{path.name}: expected CRLF-only line endings")
        source = raw.decode("utf-8")
        before_model = parse_model(source)
        output, report, unresolved, ambiguous = transform_file(domain, source, field_maps, table_maps)
        after_model = parse_model(output)
        if len(before_model) != len(after_model):
            raise ValueError(f"{path.name}: table count changed")
        if fingerprint(source) != fingerprint(output):
            raise ValueError(f"{path.name}: non-approved structural difference detected")
        all_reports[domain] = {
            "tables": len(before_model),
            "field_comments_added": report["field_comments_added"],
            "table_comments_added": report["table_comments_added"],
            "unresolved": unresolved,
            "ambiguous": ambiguous,
            "pre_sha256": hashlib.sha256(raw).hexdigest(),
            "post_sha256": hashlib.sha256(output.encode("utf-8")).hexdigest(),
            "index_risks_over_767_bytes": indexed_varchar_risks(output),
        }
        if args.apply:
            tmp = path.with_suffix(path.suffix + ".tmp")
            tmp.write_bytes(output.encode("utf-8"))
            tmp.replace(path)
    print(json.dumps(all_reports, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    main()
