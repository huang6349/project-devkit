#!/usr/bin/env bash
# Maven 3.9.5（持久化于 /data/spug/opt，容器重建不丢）
OPT_DIR=/data/spug/opt
MAVEN_VERSION=3.9.5

# 准备
mkdir -p ${OPT_DIR}

# 下载解压（已存在则跳过）
if [ ! -d "${OPT_DIR}/apache-maven-${MAVEN_VERSION}" ]; then
    echo "==> 下载 Maven ${MAVEN_VERSION}"
    wget -qO /tmp/maven.tar.gz "https://mirrors.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" || exit 1
    tar xf /tmp/maven.tar.gz -C ${OPT_DIR} || exit 1
    rm -f /tmp/maven.tar.gz
fi

# 命令链接每次确保（容器重建后 /usr/local/bin 会丢失）
ln -sf ${OPT_DIR}/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/local/bin/mvn || exit 1
echo "==> Maven 就绪: $(mvn -version | head -1)"
