#!/usr/bin/env bash
# pnpm@10（依赖 Node，调度器字母序保证 init-node 先执行）
NVM_DIR=/data/spug/opt/nvm

# Node 守卫（手动单跑时给出提示）
NODE_BIN=$(ls -d "${NVM_DIR}/versions/node/"v22.* 2>/dev/null | sort -V | tail -1)/bin
if [ ! -x "${NODE_BIN}/node" ]; then
    echo "==> Node 未安装，请先执行 init-node.sh"
    exit 1
fi

# 安装 pnpm@10（已有 10.x 则跳过，输出重定向，失败时输出）
if ! "${NODE_BIN}/pnpm" -v 2>/dev/null | grep -q "^10"; then
    echo "==> 安装 pnpm@10"
    if ! "${NODE_BIN}/npm" --registry=https://registry.npmmirror.com install -g pnpm@10 >/tmp/pnpm-install.log 2>&1; then
        echo "==> pnpm 安装失败，日志如下:"
        cat /tmp/pnpm-install.log
        exit 1
    fi
    rm -f /tmp/pnpm-install.log
fi

# 命令链接每次确保（容器重建后 /usr/local/bin 会丢失）
ln -sf ${NODE_BIN}/pnpm /usr/local/bin/pnpm || exit 1
echo "==> pnpm 就绪: $(pnpm -v 2>&1)"
