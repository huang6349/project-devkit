#!/usr/bin/env bash
# Spug 运维平台
WORKDIR=$PWD

# 加载 .env
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
set -a
source "$SCRIPT_DIR/../.env" 2>/dev/null || true
set +a

APP_NAME=${APP_NAME:-devkit}

# 准备并启动
mkdir -p $WORKDIR/service
mkdir -p $WORKDIR/repos
chmod -R 777 $WORKDIR/.
docker-compose -p ${APP_NAME}-spug up -d --build

# 初始化管理员（仅首次）
sh init-user.sh
