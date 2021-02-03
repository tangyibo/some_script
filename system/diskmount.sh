#!/bin/bash
############################################
# Function :  磁盘一键挂载挂载工具脚本
# Author : tang
# Date : 2020-11-12
#
# Usage: sh diskmount.sh /dev/sdb /data
#
############################################

# 使用说明
print_usage() {
    echo ""
    echo -e "Usage : sh $0 [device_name] [mount_path]"
    echo -e "example : sh $0 /dev/sdb /data"
    echo -e "\t device_name \t -- device name, example: /dev/sdb "
    echo -e "\t mount_path \t -- directory for mount, example: /data"
}

# 需要至少2个输入参数
if [ "$#" -lt "2" ]; then
    if [ "$#" == "0" ]; then
        echo "[ERROR]: no [device_name] and [mount_path] parameter supplied!!!"
    else
        echo "[ERROR]: no [mount_path] parameter supplied!!!"
    fi

    print_usage
    exit 1
fi

# 磁盘设备名称
device_name=$1
# 挂载目录位置
mount_path=$2
# 文件系统格式
fs_type=xfs

echo "[INFO]: available device information list follows:"
lsblk

# 检查设备是否存在
echo "[INFO]: check device [$device_name] exits status ."
fdisk -l $device_name
if [ $? -ne 0 ]; then
    echo "[ERROR]: disk device [ $device_name ] not found ."
    exit 1
fi

# 卸载挂载点，以防重复操作
umount "$device_name"1 2>&1 >/dev/null

# 磁盘分区操作
echo "[INFO]: partation for device [$device_name] ."
fdisk $device_name <<EOF
n
p
1


w
EOF
if [ $? -ne 0 ]; then
    exit 1
fi

# 磁盘格式化操作
echo "[INFO]: file system format for device $device_name"1
mkfs -t $fs_type -f "$device_name"1
if [ $? -ne 0 ]; then
    exit 1
fi

# 检查并创建挂载目录
if [ ! -d "$mount_path" ]; then
    echo "[INFO]: directory $mount_path not exit, create it now!"
    mkdir -p $mount_path
fi

# 分区挂载操作
echo "[INFO]: mount device $device_name to directory: $mount_path"
mount "$device_name"1 $mount_path
if [ $? -ne 0 ]; then
    exit 1
fi

# 配置启动挂载
exist=$(grep "$device_name""1" /etc/fstab)
if [ ! -n "$exist" ]; then
    echo "[INFO]: add....."
    echo "$device_name"1 "$mount_path $fs_type defaults 1 2" >>/etc/fstab
else
   echo "[INFO]: update....."
   sed -i "s|^$device_name"1".*$|$device_name"1" $mount_path $fs_type defaults 1 2|g" /etc/fstab
fi

# 输出挂载后的文件设备信息
df -h
echo "[INFO]: success ."
