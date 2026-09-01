#!/usr/bin/env bash
# 按序执行环境初始化脚本（init-*.sh，新增工具直接放入本目录）

for f in /data/env/init-*.sh; do
    [ -e "$f" ] || continue
    echo "==> 执行 $(basename "$f")"
    bash "$f" || exit 1
done

echo "==> 构建环境就绪"
