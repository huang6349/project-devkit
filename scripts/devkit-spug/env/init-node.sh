#!/usr/bin/env bash
# NVM + Node lts/jod（持久化于 /data/spug/opt/nvm，全走国内镜像）
export NVM_DIR=/data/spug/opt/nvm
export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node
NVM_VERSION=0.40.7
NODE_ALIAS=lts/jod

# 准备
mkdir -p ${NVM_DIR}

# 安装 nvm.sh（已存在则跳过）
if [ ! -f "${NVM_DIR}/nvm.sh" ]; then
    echo "==> 安装 NVM v${NVM_VERSION}"
    wget -qO "${NVM_DIR}/nvm.sh" "https://gitee.com/mirrors/nvm/raw/v${NVM_VERSION}/nvm.sh" || exit 1
fi

. "${NVM_DIR}/nvm.sh" || exit 1

# nvm 内部下载 node 依赖 curl/wget，两者皆无时提前失败并给出处理建议
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    echo "==> 错误: 容器内无 curl/wget，nvm 无法下载 Node"
    echo "    请在镜像内安装 curl，或将 node 包手动解压到 ${NVM_DIR}/versions/node/ 后重跑"
    exit 1
fi

# 安装 Node（已有 v22.x 则跳过，下载日志重定向，失败时输出）
if ! ls "${NVM_DIR}/versions/node/"v22.* >/dev/null 2>&1; then
    echo "==> 安装 Node ${NODE_ALIAS}"
    if ! nvm install "${NODE_ALIAS}" >/tmp/nvm-node.log 2>&1; then
        echo "==> Node 安装失败，日志如下:"
        cat /tmp/nvm-node.log
        exit 1
    fi
    rm -f /tmp/nvm-node.log
fi
nvm alias default "${NODE_ALIAS}" >/dev/null || true

NODE_BIN=$(ls -d "${NVM_DIR}/versions/node/"v22.* 2>/dev/null | sort -V | tail -1)/bin
if [ ! -x "${NODE_BIN}/node" ]; then
    echo "==> Node 安装未完成，无法继续"
    exit 1
fi

# 命令链接每次确保（容器重建后 /usr/local/bin 会丢失）
ln -sf ${NODE_BIN}/node /usr/local/bin/node
ln -sf ${NODE_BIN}/npm /usr/local/bin/npm
ln -sf ${NODE_BIN}/npx /usr/local/bin/npx
echo "==> Node 就绪: $(node -v 2>&1)"
