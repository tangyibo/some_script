#!/bin/bash
############################################
# Function :  docker一键安装脚本
# Author : tang
# Date : 2020-11-26
#
# Usage: sh install_docker.sh
#
############################################

set -e

# 安装yum源
yum -y install yum-utils
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装最新的docker软件包
yum -y install docker-ce

# 配置docker仓库源地址
mkdir -p /etc/docker/
cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors":[
        "https://docker.mirrors.ustc.edu.cn",
        "http://hub-mirror.c.163.com"
    ],
    "insecure-registries": ["127.0.0.1/8"],
    "data-root":"/var/lib/docker"
}
EOF

# 启动并查看docker服务
systemctl start docker.service
systemctl enable docker.service
systemctl status docker.service

# 下载并安装docker-compose工具
yum -y install curl
curl -L https://github.com.cnpmjs.org/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

