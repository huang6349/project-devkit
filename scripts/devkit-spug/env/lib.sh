#!/usr/bin/env bash
# 通用下载函数（wget），供 init-*.sh source 使用
download() {
    local url=$1
    local dest=$2
    wget -qO "$dest" "$url"
}
