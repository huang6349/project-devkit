#!/usr/bin/env bash
# 初始化 Spug 管理员 / 用法(容器内): bash /data/env/init-user.sh [用户名] [密码]
SPUG_USER=${1:-${SPUG_USER:-admin}}
SPUG_PASSWORD=${2:-${SPUG_PASSWORD:-pwd123456}}

# 已初始化则跳过（标记在持久卷，重建请删除 $PWD/service/.spug-initialized 后重跑）
if [ -f /data/spug/.spug-initialized ]; then
    echo "==> 管理员已初始化，跳过"
    exit 0
fi

# 等待服务就绪（最多 120s，迁移/建号日志重定向，失败时输出）
for i in $(seq 1 24); do
    if init_spug "${SPUG_USER}" "${SPUG_PASSWORD}" >/tmp/init-user.log 2>&1; then
        touch /data/spug/.spug-initialized
        echo "==> 管理员 ${SPUG_USER} 初始化完成"
        exit 0
    fi
    sleep 5
done

echo "==> 初始化未完成，最近一次执行日志如下:"
tail -50 /tmp/init-user.log 2>/dev/null
echo "    请排查后重跑 sh start.sh"
exit 1
