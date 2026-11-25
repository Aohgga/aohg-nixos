#!/usr/bin/env bash
# papirus-nixos — 为 Papirus 建薄覆盖层：只建目录骨架和 folder 链接，不复制整个主题。
# 文件夹颜色跟随 Noctalia 渲染出的 colors-final。
#
# 性能：首次（或 Papirus 包更新后）完整建一次；之后颜色变化只重写
# places 里的 folder 链接，不碰目录骨架、不重扫全部图标。
set -euo pipefail
: "${USER:=$(id -un)}"

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"
COLOR_FILE="$CONFIG_DIR/colors-final"
[[ -f "$COLOR_FILE" ]] || exit 0

mapfile -t lines <"$COLOR_FILE"
TARGET="${lines[0]//[# ]/}"
[[ ${#TARGET} -ge 6 ]] || exit 0
TARGET="${TARGET:0:6}"

MAPPING="$(printf '%s\n' "${lines[@]}" | sed '/^[[:space:]]*$/d' | tail -n1)"

# CIEDE2000 最近色：Papirus 只有固定的一批颜色，之前的 HSV 距离把色相按双方
# 饱和度加权，浅色强调色会被低饱和的 palebrown/brown 抢走（粉色主题变米色）；
# 改用感知均匀的 Lab 距离（CIEDE2000），选色和肉眼判断一致。
closest="$(
  awk -v hex="$TARGET" -v m="$MAPPING" '
  function hex2dec(h,   i,c,v,digits) {
    digits = "0123456789abcdef"; h = tolower(h); v = 0
    for (i=1; i<=length(h); i++) v = v*16 + (index(digits, substr(h,i,1)) - 1)
    return v
  }
  function srgb_lin(c) { return c <= 0.04045 ? c/12.92 : ((c+0.055)/1.055)^2.4 }
  function labf(t) { return t > 0.008856 ? t^(1/3) : 7.787*t + 16/116 }
  function rgb2lab(hex,   r,g,b,R,G,B,X,Y,Z) {
    r = hex2dec(substr(hex,1,2)); g = hex2dec(substr(hex,3,2)); b = hex2dec(substr(hex,5,2))
    R = srgb_lin(r/255); G = srgb_lin(g/255); B = srgb_lin(b/255)
    X = (R*0.4124564 + G*0.3575761 + B*0.1804375) / 0.95047
    Y = (R*0.2126729 + G*0.7151522 + B*0.0721750)
    Z = (R*0.0193339 + G*0.1191920 + B*0.9503041) / 1.08883
    LB_L = 116*labf(Y) - 16
    LB_A = 500*(labf(X) - labf(Y))
    LB_B = 200*(labf(Y) - labf(Z))
  }
  function de2000(L1,A1,B1,L2,A2,B2,   C1,C2,CB,G,A1p,A2p,C1p,C2p,H1p,H2p,dLp,dCp,dHp,dhp,Lbp,Cbp,Hbp,T,dth,RC,SL,SC,SH,RTv,PI) {
    PI = 3.141592653589793
    C1 = sqrt(A1*A1 + B1*B1); C2 = sqrt(A2*A2 + B2*B2); CB = (C1+C2)/2
    G = 0.5*(1 - sqrt(CB^7/(CB^7 + 25^7)))
    A1p = (1+G)*A1; A2p = (1+G)*A2
    C1p = sqrt(A1p*A1p + B1*B1); C2p = sqrt(A2p*A2p + B2*B2)
    H1p = atan2(B1,A1p)*180/PI; if (H1p < 0) H1p += 360
    H2p = atan2(B2,A2p)*180/PI; if (H2p < 0) H2p += 360
    dLp = L2-L1; dCp = C2p-C1p
    if (C1p*C2p == 0) { dHp = 0 }
    else {
      dhp = H2p-H1p
      if (dhp > 180) dhp -= 360
      else if (dhp < -180) dhp += 360
      dHp = 2*sqrt(C1p*C2p)*sin(dhp*PI/360)
    }
    Lbp = (L1+L2)/2; Cbp = (C1p+C2p)/2
    if (C1p*C2p == 0) { Hbp = H1p+H2p }
    else if ((H1p-H2p < 0 ? H2p-H1p : H1p-H2p) > 180) {
      Hbp = (H1p+H2p < 360) ? (H1p+H2p+360)/2 : (H1p+H2p-360)/2
    } else { Hbp = (H1p+H2p)/2 }
    T = 1 - 0.17*cos((Hbp-30)*PI/180) + 0.24*cos(2*Hbp*PI/180) \
          + 0.32*cos((3*Hbp+6)*PI/180) - 0.20*cos((4*Hbp-63)*PI/180)
    dth = 30*exp(-((Hbp-275)/25)^2)
    RC = 2*sqrt(Cbp^7/(Cbp^7 + 25^7))
    SL = 1 + 0.015*(Lbp-50)^2/sqrt(20 + (Lbp-50)^2)
    SC = 1 + 0.045*Cbp
    SH = 1 + 0.015*Cbp*T
    RTv = -sin(2*dth*PI/180)*RC
    return sqrt((dLp/SL)^2 + (dCp/SC)^2 + (dHp/SH)^2 + RTv*(dCp/SC)*(dHp/SH))
  }
  BEGIN {
    n = split(m, arr)
    rgb2lab(hex); tL = LB_L; tA = LB_A; tB = LB_B
    for (i=1; i<=n; i++) {
      split(arr[i], p, ":")
      rgb2lab(p[2])
      d = de2000(tL, tA, tB, LB_L, LB_A, LB_B)
      if (min == "" || d < min) { min = d; best = p[1] }
    }
    print best
  }'
)"
[[ -n "$closest" ]] || { echo "papirus-nixos: 没有匹配的颜色" >&2; exit 0; }

colors=()
for pair in $MAPPING; do colors+=("${pair%%:*}"); done

DEST="$HOME/.local/share/icons/Papirus"
SIZES="16x16 18x18 22x22 24x24 32x32 48x48 64x64 96x96 128x128"

# 颜色没变就跳过重写链接，但仍要保证 Dark/Light 指向 Papirus 覆盖层
SAME=0
if [[ -z "${PAPIRUS_THIN_FORCE:-}" ]] &&
  [[ -f "$DEST/48x48/places/folder.svg" ]] &&
  [[ "$(readlink -f "$DEST/48x48/places/folder.svg")" == *"/folder-$closest.svg" ]]; then
  SAME=1
fi

# 找系统 Papirus：XDG_DATA_DIRS + systemPackages / home-manager / nix profile
dirs=()
IFS=: read -ra dirs <<<"${XDG_DATA_DIRS:-}"
for d in \
  "/run/current-system/sw/share" \
  "/etc/profiles/per-user/${USER}/share" \
  "$HOME/.local/state/nix/profiles/home-manager/share" \
  "$HOME/.nix-profile/share" \
  "/usr/local/share" \
  "/usr/share"; do
  dirs+=("$d")
done

find_src() {
  local v=$1 d
  for d in "${dirs[@]}"; do
    [[ -n "$d" && -d "$d/icons/$v" ]] || continue
    readlink -f "$d/icons/$v"
    return 0
  done
  return 1
}

# folder-<颜色>.svg / folder-<颜色>-x.svg / user-<颜色>-x.svg 是颜色变体
is_color_variant() {
  local base=$1 c
  for c in "${colors[@]}"; do
    [[ "$base" == "folder-$c" || "$base" == folder-"$c"-* ]] && return 0
    [[ "$base" == "user-$c" || "$base" == user-"$c"-* ]] && return 0
  done
  return 1
}

# 把一个 places 图标解析成带 %C% 占位的目标文件名；空输出表示不参与改色。
# folder-/user- 前缀直接替换；其余别名（inode-directory 等）解析系统文件的
# 真实目标，再看它是不是默认的 blue 变体。
resolve_template() {
  local entry=$1 real rel base
  real="$(readlink -f "$entry")"
  rel="${real#"$ROOT"/}"
  case "$rel" in
    *folder-blue*) printf '%s' "${rel/folder-blue/folder-%C%}" ;;
    *user-blue*) printf '%s' "${rel/user-blue/user-%C%}" ;;
    *)
      # 本尺寸没有颜色变体（folder.svg 是真实文件）时，借用 48x48 的变体
      base="${entry##*/}"
      base="${base%.svg}"
      case "$base" in
        folder) [[ -e "$ROOT/48x48/places/folder-$closest.svg" ]] && printf '48x48/places/folder-%%C%%.svg' ;;
        folder-*) [[ -e "$ROOT/48x48/places/folder-$closest-${base#folder-}.svg" ]] && printf '48x48/places/folder-%%C%%-%s' "${base#folder-}" ;;
        user) [[ -e "$ROOT/48x48/places/user-$closest.svg" ]] && printf '48x48/places/user-%%C%%.svg' ;;
        user-*) [[ -e "$ROOT/48x48/places/user-$closest-${base#user-}.svg" ]] && printf '48x48/places/user-%%C%%-%s' "${base#user-}" ;;
      esac
      ;;
  esac
  return 0
}

# 首次构建：完整骨架 + 每个 places 的颜色目标清单（.colorfiles）
build_places_full() {
  local src=$1 dest=$2 entry name base tmpl
  mkdir -p "$dest"
  : >"$dest/.colorfiles"
  for entry in "$src"/*.svg; do
    [[ -e "$entry" || -L "$entry" ]] || continue
    name="${entry##*/}"
    base="${name%.svg}"
    is_color_variant "$base" && continue
    tmpl="$(resolve_template "$entry" "$base")"
    if [[ -n "$tmpl" ]]; then
      ln -sfn "$ROOT/${tmpl//%C%/$closest}" "$dest/$name"
      printf '%s|%s\n' "$name" "$tmpl" >>"$dest/.colorfiles"
    else
      ln -sfn "$(readlink -f "$entry")" "$dest/$name"
    fi
  done
}

build_size_full() {
  local src=$1 dest=$2 entry name
  mkdir -p "$dest"
  for entry in "$src"/*; do
    [[ -e "$entry" || -L "$entry" ]] || continue
    name="${entry##*/}"
    if [[ "$name" == places ]]; then
      build_places_full "$src/places" "$dest/places"
    else
      ln -sfn "$(readlink -f "$entry")" "$dest/$name"
    fi
  done
}

build_full() {
  local src=$1 dest=$2 entry name base
  rm -rf "$dest"
  mkdir -p "$dest"
  cp -f "$src/index.theme" "$dest/index.theme"
  printf '%s' "$src" >"$dest/.papirus-thin-src"
  for entry in "$src"/*; do
    [[ -e "$entry" || -L "$entry" ]] || continue
    name="${entry##*/}"
    case "$name" in
      index.theme | icon-theme.cache) continue ;;
    esac
    case "$name" in
      *@2x)
        base="${name%@2x}"
        if [[ " $SIZES " == *" $base "* ]]; then
          ln -sfn "$dest/$base" "$dest/$name"
        else
          ln -sfn "$(readlink -f "$entry")" "$dest/$name"
        fi
        ;;
      *)
        case " $SIZES " in
          *" $name "*) build_size_full "$entry" "$dest/$name" ;;
          *) ln -sfn "$(readlink -f "$entry")" "$dest/$name" ;;
        esac
        ;;
    esac
  done
}

# 增量：只重写颜色相关链接
build_incr() {
  local src=$1 dest=$2 size name tmpl list jobs
  list="$(mktemp)"
  for size in $SIZES; do
    [[ -f "$dest/$size/places/.colorfiles" ]] || continue
    while IFS='|' read -r name tmpl; do
      [[ -n "$name" ]] || continue
      printf '%s\0%s\0' "$ROOT/${tmpl//%C%/$closest}" "$dest/$size/places/$name"
    done <"$dest/$size/places/.colorfiles"
  done >"$list"
  jobs="$(nproc 2>/dev/null || echo 4)"
  xargs -0 -r -n2 -P"$jobs" ln -sfn <"$list"
  rm -f "$list"
}

# Dark/Light 变体：骨架沿用系统图标，places 直接指向 Papirus 覆盖层，
# 这样只维护 Papirus 的链接就够，Luciole 等按 gsettings 用 Dark 的应用也能跟随。
ensure_variant() {
  local variant=$1 vsrc=$2 vdest="$HOME/.local/share/icons/$1" entry name sub subname
  [[ -n "$vsrc" && -d "$vsrc" ]] || return 0
  if [[ -f "$vdest/.papirus-thin-src" ]] && [[ "$(cat "$vdest/.papirus-thin-src")" == "$vsrc" ]]; then
    return 0
  fi
  if [[ -d "$vdest" && ! -f "$vdest/.papirus-thin-src" ]]; then
    echo "papirus-nixos: 跳过 $vdest（已存在且不是本模板建的目录）" >&2
    return 0
  fi
  rm -rf "$vdest"
  mkdir -p "$vdest"
  cp -f "$vsrc/index.theme" "$vdest/index.theme"
  printf '%s' "$vsrc" >"$vdest/.papirus-thin-src"
  for entry in "$vsrc"/*; do
    [[ -e "$entry" || -L "$entry" ]] || continue
    name="${entry##*/}"
    case "$name" in
      index.theme | icon-theme.cache) continue ;;
    esac
    case "$name" in
      *@2x)
        ln -sfn "$vdest/${name%@2x}" "$vdest/$name"
        ;;
      *)
        case " $SIZES " in
          *" $name "*)
            mkdir -p "$vdest/$name"
            ln -sfn "$DEST/$name/places" "$vdest/$name/places"
            for sub in "$entry"/*; do
              [[ -e "$sub" || -L "$sub" ]] || continue
              subname="${sub##*/}"
              [[ "$subname" == places ]] && continue
              ln -sfn "$(readlink -f "$sub")" "$vdest/$name/$subname"
            done
            ;;
          *)
            ln -sfn "$(readlink -f "$entry")" "$vdest/$name"
            ;;
        esac
        ;;
    esac
  done
}

ROOT="$(find_src Papirus)" || { echo "papirus-nixos: 未找到 Papirus" >&2; exit 0; }

# 颜色没变且 Dark/Light 都已就绪：直接退出
if [[ $SAME -eq 1 ]]; then
  fresh=1
  for v in Papirus-Dark Papirus-Light; do
    vsrc="$(find_src "$v")" || { fresh=0; break; }
    [[ -f "$HOME/.local/share/icons/$v/.papirus-thin-src" ]] || { fresh=0; break; }
    [[ "$(cat "$HOME/.local/share/icons/$v/.papirus-thin-src")" == "$vsrc" ]] || { fresh=0; break; }
  done
  [[ $fresh -eq 1 ]] && exit 0
fi

if [[ -d "$DEST" && ! -f "$DEST/.papirus-thin-src" ]]; then
  echo "papirus-nixos: 跳过 $DEST（已存在且不是本模板建的目录）" >&2
  exit 0
fi

if [[ $SAME -eq 0 ]] && { [[ ! -f "$DEST/.papirus-thin-src" ]] || [[ "$(cat "$DEST/.papirus-thin-src")" != "$ROOT" ]]; }; then
  build_full "$ROOT" "$DEST"
  if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -qf "$DEST" >/dev/null 2>&1 || true
  fi
elif [[ $SAME -eq 0 ]]; then
  build_incr "$ROOT" "$DEST"
fi

# Dark/Light：places 指向 Papirus 覆盖层，跟随颜色变化
for variant in Papirus-Dark Papirus-Light; do
  vsrc="$(find_src "$variant")" || continue
  ensure_variant "$variant" "$vsrc"
done
