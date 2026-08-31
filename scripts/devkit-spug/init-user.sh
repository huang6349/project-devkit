#!/usr/bin/env bash
# 初始化 Spug 管理员 / 用法: sh init-user.sh [用户名] [密码]
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# 加载 .env
set -a
source "$SCRIPT_DIR/../.env" 2>/dev/null || true
set +a

APP_NAME=${APP_NAME:-devkit}
SPUG_USER=${1:-${SPUG_USER:-admin}}
SPUG_PASSWORD=${2:-${SPUG_PASSWORD:-pwd123456}}

# 已初始化则跳过（宿主机标记，重建请删除标记后重跑）
if [ -f "$SCRIPT_DIR/.spug-initialized" ]; then
    echo "==> 已初始化，跳过"
    exit 0
fi

# 等待服务就绪（最多 120s）
for i in $(seq 1 24); do
    if docker exec ${APP_NAME}-spug init_spug "${SPUG_USER}" "${SPUG_PASSWORD}"; then
        touch "$SCRIPT_DIR/.spug-initialized"
        echo "==> 管理员 ${SPUG_USER} 初始化完成"
        exit 0
    fi
    sleep 5
done

echo "==> 初始化未完成，请稍后重跑 sh init-user.sh"
exit 1
