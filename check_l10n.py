import json
import os
import re

lib_dir = "c:/Users/Lenovo/StudioProjects/bandtech/al_andalus/lib"
ar_file = os.path.join(lib_dir, "l10n", "intl_ar.arb")
en_file = os.path.join(lib_dir, "l10n", "intl_en.arb")

with open(ar_file, 'r', encoding='utf-8') as f:
    ar_data = json.load(f)

with open(en_file, 'r', encoding='utf-8') as f:
    en_data = json.load(f)

ar_keys = set(ar_data.keys())
en_keys = set(en_data.keys())

all_keys = ar_keys.union(en_keys)
all_keys = {k for k in all_keys if not k.startswith('@')}

used_keys = set()
exceptions = set()

for root, dirs, files in os.walk(lib_dir):
    for filename in files:
        if filename.endswith(".dart"):
            filepath = os.path.join(root, filename)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                    matches = re.findall(r'\bS\.(?:of\(context\)|current)\.([a-zA-Z0-9_]+)\b', content)
                    used_keys.update(matches)
            except Exception as e:
                pass

unused_keys = all_keys - used_keys

print(f"Total keys: {len(all_keys)}")
print(f"Used keys: {len(used_keys)}")
print(f"Unused keys (excluding possible dynamic usages): {len(unused_keys)}")

print("\n--- In AR but not in EN ---")
for k in sorted(list(ar_keys - en_keys)):
    print(k)

print("\n--- In EN but not in AR ---")
for k in sorted(list(en_keys - ar_keys)):
    print(k)

# output the unused keys to a file for easy reading
with open("c:/Users/Lenovo/StudioProjects/bandtech/al_andalus/unused_keys.txt", "w", encoding="utf-8") as out:
    for k in sorted(list(unused_keys)):
        out.write(f"{k}\n")
print("Unused keys written to unused_keys.txt")
