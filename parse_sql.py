# -*- coding: utf-8 -*-
"""解析 training.sql，提取所有表结构与字段信息，输出中间 JSON。"""
import re, json, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

with open('training.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# 按 CREATE TABLE 语句拆分
# 匹配 CREATE TABLE `name` ( ... ) ENGINE = ... ;
tables = []

# 逐个匹配 CREATE TABLE 块
pattern = re.compile(
    r"CREATE TABLE `(?P<name>[^`]+)`\s*\((?P<body>.*?)\)\s*(?P<opts>ENGINE[^;]*);",
    re.DOTALL
)

for m in pattern.finditer(sql):
    name = m.group('name')
    body = m.group('body')
    opts = m.group('opts')

    # 表注释
    tcm = re.search(r"COMMENT\s*=\s*'((?:[^'\\]|\\.)*)'", opts)
    table_comment = tcm.group(1).replace("\\'", "'") if tcm else ''

    # 引擎
    eng = re.search(r"ENGINE\s*=\s*(\w+)", opts)
    engine = eng.group(1) if eng else ''

    # AUTO_INCREMENT
    ai = re.search(r"AUTO_INCREMENT\s*=\s*(\d+)", opts)
    auto_inc = int(ai.group(1)) if ai else None

    # 解析字段：逐行处理 body
    fields = []
    for line in body.split('\n'):
        line = line.strip()
        if not line:
            continue
        # 只处理字段定义行： `field` type ...
        fm = re.match(r"`(?P<fn>[^`]+)`\s+(?P<rest>.+)", line)
        if not fm:
            # 跳过 PRIMARY KEY / KEY / INDEX / CONSTRAINT / UNIQUE 等
            continue
        fn = fm.group('fn')
        rest = fm.group('rest').rstrip(',').strip()

        # 字段类型：取第一个 token（含括号内容），如 int(11), varchar(50), decimal(10, 2), tinyint(1) unsigned
        # 匹配类型 + 可选括号 + 可选 unsigned/zerofill
        tm = re.match(r"(?P<type>\w+(?:\s*\([^)]*\))?(?:\s+(?:unsigned|zerofill))*)", rest, re.IGNORECASE)
        ftype = tm.group('type').strip() if tm else ''
        # 规范化：去掉多余空格
        ftype = re.sub(r"\s+", " ", ftype)

        # 字段注释
        fcm = re.search(r"COMMENT\s+'((?:[^'\\]|\\.)*)'", rest)
        fcomment = fcm.group(1).replace("\\'", "'") if fcm else ''

        fields.append({
            'field': fn,
            'comment': fcomment,
            'type': ftype,
        })

    tables.append({
        'name': name,
        'comment': table_comment,
        'engine': engine,
        'auto_inc': auto_inc,
        'fields': fields,
    })

print('总表数:', len(tables))
no_tc = [t['name'] for t in tables if not t['comment']]
print('无表注释的表 (%d):' % len(no_tc))
for n in no_tc:
    print('   ', n)

# 统计无字段注释情况
print('\n各表字段注释缺失统计:')
for t in tables:
    total = len(t['fields'])
    miss = sum(1 for fld in t['fields'] if not fld['comment'])
    if miss:
        print('  %-45s 字段 %d, 缺注释 %d' % (t['name'], total, miss))

with open('_parsed_tables.json', 'w', encoding='utf-8') as f:
    json.dump(tables, f, ensure_ascii=False, indent=2)
print('\n已写出 _parsed_tables.json')
