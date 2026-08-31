# -*- coding: utf-8 -*-
from pathlib import Path
import re

files = [
    Path('20260804-重建数据库/jianengliang.sql'),
    Path('20260804-重建数据库/training.sql'),
    Path('20260804-重建数据库/vmdb.sql'),
]
for path in files:
    data = path.read_bytes()
    text = data.decode('utf-8')
    print(
        path.name,
        'bom=' + str(data.startswith(b'\xef\xbb\xbf')),
        'bare_lf=' + str(b'\n' in data.replace(b'\r\n', b'')),
        'tables=' + str(len(re.findall(r'CREATE TABLE `', text))),
        'legacy_charset=' + str(len(re.findall(r'CHARACTER SET =? utf8(?!mb4)', text, re.I))),
        'legacy_collate=' + str(len(re.findall(r'COLLATE =? utf8_(?!mb4)', text, re.I))),
        'utf8mb4=' + str(len(re.findall(r'utf8mb4', text, re.I))),
    )
