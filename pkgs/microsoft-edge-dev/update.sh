#!/usr/bin/env bash
# shellcheck disable=SC2128,SC2178

VER_SAME=0
VER_LEFT_NEWER=1
VER_RIGHT_NEWER=2

_version_compare() {
    if (($1 < $2)); then
        return $VER_RIGHT_NEWER
    elif (($2 < $1)); then
        return $VER_LEFT_NEWER
    else
        return $VER_SAME
    fi
}

version_compare() {
    local left_version
    local right_version
    local i
    OLDIFS=$IFS
    IFS=.
    read -r -a left_version <<<"$1"
    read -r -a right_version <<<"$2"
    IFS=$OLDIFS
    for i in {0..3}; do
        _version_compare "${left_version[i]}" "${right_version[i]}"
        case $? in
        "$VER_SAME") ;;
        *)
            return $?
            ;;
        esac
    done
    return $VER_SAME
}

repo_url=https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev

mapfile -t index < <(curl -fsSL "$repo_url" | tail -n+7 | head -n-2 | sed -E 's/^.*>(.*)<.*$/\1/')

if ((${#index[@]} <= 0)); then
    printf "error: index is empty"
    exit 1
fi

latest_version=${index[0]#microsoft-edge-dev_}
latest_version=${latest_version%-1_amd64.deb}

for ((i = 1; i < ${#index[@]}; i++)); do
    left_version=$latest_version
    right_version=${index[i]#microsoft-edge-dev_}
    right_version=${right_version%-1_amd64.deb}
    version_compare "$left_version" "$right_version"
    if [[ $? == "$VER_RIGHT_NEWER" ]]; then
        latest_version=$right_version
    fi
done

sed -i "$(dirname "$(realpath "$0")")/default.nix" \
    -e 's/^  version = ".*";$/  version = "'"$latest_version"'";/' \
    -e 's:^    hash = ".*";$:    hash = "'"$(nix hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url "$repo_url/microsoft-edge-dev_$latest_version-1_amd64.deb")")"'";:'
