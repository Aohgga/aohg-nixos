#!/usr/bin/env bash
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
gtk_css="$config_dir/gtk-3.0/gtk.css"
imports=('@import url("colors.css");' '@import url("colors-extras.css");')

mkdir -p "$(dirname "$gtk_css")"
touch "$gtk_css"

# 不写临时文件：Noctalia 重启时会终止还在跑的 hook，mktemp 留的文件来不及被
# trap 清掉，会在 gtk 目录里慢慢堆出 gtk.css.tmp.XXXXXX。改成就地重写。
missing=()
for import_line in "${imports[@]}"; do
    grep -qxF "$import_line" "$gtk_css" || missing+=("$import_line")
done

if [ ${#missing[@]} -gt 0 ]; then
    content="$(
        awk -v want="$(printf '%s\n' "${missing[@]}")" '
            BEGIN { n = split(want, lines, "\n"); inserted = 0 }
            {
                line = $0
                if (!inserted &&
                    line !~ /^[[:space:]]*$/ &&
                    line !~ /^[[:space:]]*\/\*/ &&
                    line !~ /^[[:space:]]*\*/ &&
                    line !~ /^[[:space:]]*@import/) {
                    for (i = 1; i <= n; i++) print lines[i]
                    inserted = 1
                }
                print line
            }
            END {
                if (!inserted) for (i = 1; i <= n; i++) print lines[i]
            }
        ' "$gtk_css"
    )"
    printf '%s\n' "$content" >"$gtk_css"
fi

# Ask GTK to re-read its user stylesheet so running apps pick up the new colors.
touch "$gtk_css" 2>/dev/null || true
