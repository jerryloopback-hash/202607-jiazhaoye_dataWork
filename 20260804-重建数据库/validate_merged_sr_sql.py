# -*- coding: utf-8 -*-
from pathlib import Path
import importlib.util
import json
import re

root = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('builder', root / 'build_merged_sr_sql.py')
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)
target = root / '文体_ods_建表.sql'
raw = target.read_bytes()
text = raw.decode('utf-8')
assert not raw.startswith(b'\xef\xbb\xbf')
assert b'\n' not in raw.replace(b'\r\n', b'')
blocks = list(builder.CREATE_RE.finditer(text))
assert len(blocks) == 100
names = [m.group('name') for m in blocks]
assert len(names) == len(set(names)) == 100
assert len(re.findall(r'DROP TABLE IF EXISTS `', text)) == 100
assert text.count('DEFAULT CHARACTER SET = utf8mb4') == 100
assert text.count('COLLATE = utf8mb4_unicode_ci') == 100
assert not re.search(r'\bCHARACTER SET\b(?!\s*=\s*utf8mb4)', text, re.I)
assert not re.search(r'\bCOLLATE\b(?!\s*=\s*utf8mb4_unicode_ci)', text, re.I)
assert len(re.findall(r'-- ods_wenti_(?:jianengliang|training|vmdb)_', text)) == 100
assert 'ods_wenti_training_h_card' in names
assert 'ods_wenti_vmdb_h_card' in names
assert 'ods_wenti_training_m_trade_order' in names
assert 'ods_wenti_vmdb_m_trade_order' in names
source_models = {}
for domain, path in builder.SOURCES:
    source = builder.strict_utf8_crlf(path)
    for match in builder.CREATE_RE.finditer(source):
        source_models[(domain, builder.sr_name(domain, match.group('name')))] = builder.normalized_model(match.group('name'), match.group('body'), match.group('opts'))
target_models = {}
for match in blocks:
    name = match.group('name')
    domain = name[len(builder.PREFIX):].split('_', 1)[0]
    target_models[(domain, name)] = builder.normalized_model(builder.PREFIX + name.split('_', 3)[-1], match.group('body'), match.group('opts'))
assert set(source_models) == set(target_models)
for key in source_models:
    if source_models[key] != target_models[key]:
        print('SOURCE', json.dumps(source_models[key], ensure_ascii=False, indent=2))
        print('TARGET', json.dumps(target_models[key], ensure_ascii=False, indent=2))
        raise AssertionError(f'schema differs: {key}')
print(json.dumps({'tables': len(names), 'unique_names': len(set(names)), 'encoding': 'utf-8-no-bom-crlf', 'source_structures_preserved': len(source_models)}, ensure_ascii=False))
