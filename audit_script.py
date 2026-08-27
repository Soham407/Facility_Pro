import os
import re

issues = []
for root, dirs, files in os.walk('src'):
    for file in files:
        if file.endswith('.ts') or file.endswith('.tsx'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
                # Check for direct supabase imports (AGENTS.md rule)
                if 'import { createClient } from "@supabase/supabase-js"' in content or 'import { createBrowserClient } from "@supabase/ssr"' in content:
                    if 'lib/supabase' not in path and 'hooks/use' not in path:
                        issues.append(f"VIOLATION (Direct Supabase Client): {path}")
                # Check for missing return types
                # Just a quick check for 'any' types
                if ' as any' in content:
                    issues.append(f"WARNING (Uses 'as any'): {path}")
                # Check for strict null checks (which shouldn't be added, per AGENTS.md, but 'any' is bad)
                if '@ts-ignore' in content:
                    issues.append(f"WARNING (Uses @ts-ignore): {path}")
                # Check for hardcoded UUIDs
                if re.search(r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}', content):
                    issues.append(f"WARNING (Hardcoded UUID): {path}")

for root, dirs, files in os.walk('app'):
    for file in files:
        if file.endswith('.ts') or file.endswith('.tsx'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
                # Check for direct supabase imports in UI (AGENTS.md rule)
                if 'import { createClient }' in content or '@supabase/' in content:
                    issues.append(f"VIOLATION (UI Direct Supabase Client): {path}")
                if 'mock' in content.lower():
                    issues.append(f"WARNING (Mock Data): {path}")

with open('audit_results.txt', 'w') as f:
    f.write('\n'.join(issues))
