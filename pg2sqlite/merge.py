creates = open('tennis-predata.sql').read().split(');')
creates = [s.strip() for s in creates]
del creates[-1]
d = dict()
for c in creates:
	d[c.split()[2]] = c
creates = d

keys = open('tennis-postdata.sql').read().split(');')
keys = [s.strip() for s in keys]
del keys[-1]
keys = [s.replace('ALTER TABLE ONLY ', '') for s in keys]
fkeys = [s for s in keys if '_fkey' in s]
pkeys = [s for s in keys if '_pkey' in s]
d = dict()
for k in fkeys:
    s = k.split(' ADD CONSTRAINT ')
    val = s[1].split(' ', 1)[1]
    d[s[0].strip()] = val
fkeys = d
d2 = dict()
for k in pkeys:
    s = k.split(' ADD CONSTRAINT ')
    val = s[1].split(' ', 1)[1]
    d2[s[0].strip()] = val
pkeys = d2

for create in creates:
    if pkeys.get(create) is not None:
        creates[create] += ',\n'
        creates[create] += pkeys[create] + ')'
    if fkeys.get(create) is not None:
        creates[create] += ',\n'
        creates[create] += fkeys[create] + ')'
    creates[create] += '\n);'

    print(creates[create])
#print(fkeys)
