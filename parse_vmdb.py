# -*- coding: utf-8 -*-
"""解析 vmdb.sql (Navicat dump)，提取所有表结构与字段信息，输出中间 JSON 并做诊断。"""
import re, json, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

with open('vmdb.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# 匹配每个 CREATE TABLE 块： CREATE TABLE `name` ( ... ) ENGINE...;
pattern = re.compile(
    r"CREATE TABLE `(?P<name>[^`]+)`\s*\((?P<body>.*?)\)\s*(?P<opts>ENGINE[^;]*);",
    re.DOTALL
)

def unesc(s):
    return s.replace("\\'", "'").replace('\\"', '"') if s else s

tables = []
for m in pattern.finditer(sql):
    name = m.group('name')
    body = m.group('body')
    opts = m.group('opts')

    tcm = re.search(r"COMMENT\s*=\s*'((?:[^'\\]|\\.)*)'", opts)
    table_comment = unesc(tcm.group(1)) if tcm else ''

    eng = re.search(r"ENGINE\s*=\s*(\w+)", opts)
    engine = eng.group(1) if eng else ''

    ai = re.search(r"AUTO_INCREMENT\s*=\s*(\d+)", opts)
    auto_inc = int(ai.group(1)) if ai else None

    fields = []
    for raw in body.split('\n'):
        line = raw.strip()
        if not line:
            continue
        fm = re.match(r"`(?P<fn>[^`]+)`\s+(?P<rest>.+)", line)
        if not fm:
            continue  # 跳过 PRIMARY KEY / KEY / INDEX / CONSTRAINT / UNIQUE
        fn = fm.group('fn')
        rest = fm.group('rest').rstrip(',').strip()

        # 类型： 首 token + 可选括号 + unsigned/zerofill
        tm = re.match(r"(?P<type>\w+(?:\s*\([^)]*\))?(?:\s+(?:unsigned|zerofill))*)", rest, re.I)
        ftype = re.sub(r"\s+", " ", tm.group('type').strip()) if tm else ''

        fcm = re.search(r"COMMENT\s+'((?:[^'\\]|\\.)*)'", rest)
        fcomment = unesc(fcm.group(1)) if fcm else ''

        fields.append({'field': fn, 'comment': fcomment, 'type': ftype})

    tables.append({
        'name': name, 'comment': table_comment, 'engine': engine,
        'auto_inc': auto_inc, 'fields': fields,
    })

print('总表数:', len(tables))
no_tc = [t['name'] for t in tables if not t['comment']]
print('\n无表注释的表 (%d 张):' % len(no_tc))
for n in no_tc:
    print('   ', n)

print('\n各表字段注释缺失统计 (仅列出有缺失的表):')
total_miss = 0
for t in tables:
    tot = len(t['fields'])
    miss = [f['field'] for f in t['fields'] if not f['comment']]
    total_miss += len(miss)
    if miss:
        print('  %-42s 字段 %2d, 缺注释 %2d: %s' % (t['name'], tot, len(miss), ', '.join(miss)))
print('\n字段总缺注释数:', total_miss)

with open('_vmdb_tables.json', 'w', encoding='utf-8') as f:
    json.dump(tables, f, ensure_ascii=False, indent=2)
print('已写出 _vmdb_tables.json')
