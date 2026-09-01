#!/usr/bin/env bash
# JDK 17（持久化于 /data/spug/opt，容器重建不丢）
OPT_DIR=/data/spug/opt
JDK_VERSION=17.0.2

# 准备
mkdir -p ${OPT_DIR}

# 下载解压（已存在则跳过）
if [ ! -d "${OPT_DIR}/jdk-${JDK_VERSION}" ]; then
    echo "==> 下载 JDK ${JDK_VERSION}"
    wget -qO /tmp/jdk.tar.gz "https://mirrors.huaweicloud.com/openjdk/${JDK_VERSION}/openjdk-${JDK_VERSION}_linux-x64_bin.tar.gz" || exit 1
    tar xf /tmp/jdk.tar.gz -C ${OPT_DIR} || exit 1
    rm -f /tmp/jdk.tar.gz
fi

# 命令链接每次确保（容器重建后 /usr/local/bin 会丢失）
ln -sf ${OPT_DIR}/jdk-${JDK_VERSION}/bin/java /usr/local/bin/java || exit 1
echo "==> JDK 就绪: $(java -version 2>&1 | head -1)"
