import re
import pathlib

derive_re = re.compile(r'^(\s*)\} derive\(([^)]*)\)\s*$')
decl_re = re.compile(r'(struct|enum)\s+[A-Za-z_][A-Za-z0-9_]*.*\{\s*$')

changed_files = 0
total = 0
for p in pathlib.Path('.').rglob('*.mbt'):
    s = str(p)
    if '_build' in s or '.git' in s:
        continue
    text = p.read_text(encoding='utf-8')
    lines = text.split('\n')
    out = []
    i = 0
    n_change = 0
    while i < len(lines):
        m = derive_re.match(lines[i])
        if not m:
            out.append(lines[i])
            i += 1
            continue
        indent = m.group(1)
        traits = m.group(2).strip()
        decl_idx = None
        for j in range(len(out) - 1, -1, -1):
            if decl_re.search(out[j]):
                decl_idx = j
                break
        if decl_idx is None:
            out.append(lines[i])
            i += 1
            continue
        out.append(f'{indent}}}')
        out.insert(decl_idx, f'{indent}#derive({traits})')
        n_change += 1
        i += 1
    if n_change:
        p.write_text('\n'.join(out), encoding='utf-8')
        changed_files += 1
        total += n_change

print(f'files={changed_files} derive_migrated={total}')
