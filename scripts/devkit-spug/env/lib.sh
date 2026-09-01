#!/usr/bin/env bash
# 通用下载函数（curl → wget → python3 兜底），供 init-*.sh source 使用
download() {
    local url=$1
    local dest=$2
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL -o "$dest" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$dest" "$url"
    else
        python3 -c "import urllib.request,sys; urllib.request.urlretrieve(sys.argv[1], sys.argv[2])" "$url" "$dest"
    fi
}
