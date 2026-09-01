#!/usr/bin/env bash
# 安装 NVM + Node lts/jod + pnpm@10（持久化于 /data/spug/opt/nvm，全走国内镜像）
set -e
export NVM_DIR=/data/spug/opt/nvm
export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node
NODE_ALIAS=lts/jod

# 安装 NVM（已存在则跳过，PROFILE=/dev/null 避免改写 /root/.bashrc）
if [ ! -f "${NVM_DIR}/nvm.sh" ]; then
    echo "==> 安装 NVM"
    PROFILE=/dev/null bash -c "$(curl -fsSL "https://gitee.com/RubyMetric/nvm-cn/raw/main/install.sh")"
fi

. "${NVM_DIR}/nvm.sh"

# 安装 Node（已有 v22.x 则跳过）
if ! ls "${NVM_DIR}/versions/node/"v22.* >/dev/null 2>&1; then
    echo "==> 安装 Node ${NODE_ALIAS}"
    nvm install "${NODE_ALIAS}"
fi
nvm alias default "${NODE_ALIAS}"

NODE_BIN=$(ls -d "${NVM_DIR}/versions/node/"v22.* | sort -V | tail -1)/bin

# 安装 pnpm@10（已有 10.x 则跳过）
if ! "${NODE_BIN}/pnpm" -v 2>/dev/null | grep -q "^10"; then
    echo "==> 安装 pnpm@10"
    npm --registry=https://registry.npmmirror.com install -g pnpm@10
fi

# 命令链接每次确保（容器重建后 /usr/local/bin 会丢失）
ln -sf ${NODE_BIN}/node /usr/local/bin/node
ln -sf ${NODE_BIN}/npm /usr/local/bin/npm
ln -sf ${NODE_BIN}/npx /usr/local/bin/npx
ln -sf ${NODE_BIN}/pnpm /usr/local/bin/pnpm
echo "==> Node 就绪: $(node -v), pnpm $(pnpm -v)"
