#!/usr/bin/env bash
# 安装 Maven 3.9.5（持久化于 /data/spug/opt）
set -e
. /data/env/lib.sh
OPT_DIR=/data/spug/opt
MAVEN_VERSION=3.9.5
mkdir -p ${OPT_DIR}

# 下载解压（已存在则跳过）
if [ ! -d "${OPT_DIR}/apache-maven-${MAVEN_VERSION}" ]; then
    echo "==> 下载 Maven ${MAVEN_VERSION}"
    download "https://mirrors.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" /tmp/maven.tar.gz
    tar xf /tmp/maven.tar.gz -C ${OPT_DIR}
    rm -f /tmp/maven.tar.gz
fi

# 命令链接每次确保（容器重建后 /usr/local/bin 会丢失）
ln -sf ${OPT_DIR}/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/local/bin/mvn
echo "==> Maven 就绪: $(mvn -version | head -1)"
