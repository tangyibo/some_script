#!/bin/bash
############################################
# Function :  CentOS7一键升级内核
# Author : tang
# Date : 2020-11-26
#
# Usage: sh update_kernel_to_latest.sh
#
############################################

#set -e

# 导入公钥
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

# 安装elrepo
yum install -y https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm

# 安装 yum-utils工具
yum install -y yum-utils

# 载入elrepo-kernel元数据
yum --disablerepo=* --enablerepo=elrepo-kernel repolist

# 查看可用的rpm包
yum --disablerepo=* --enablerepo=elrepo-kernel list kernel*

# 安装最新版Kernel
yum --disablerepo=* --enablerepo=elrepo-kernel install -y kernel-ml.x86_64

# 查看系统上的所有可用内核：
awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg

# 设置新的内核为grub2的默认版本
grub2-set-default 0

# 生成 grub 配置文件并重启
grub2-mkconfig -o /boot/grub2/grub.cfg

#删除旧版本
package-cleanup --oldkernels

# 重启
reboot
