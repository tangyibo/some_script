
# CentOS7操作系统常用一键操作SHELL脚本

## docker相关

- docker/install_docker.sh: docker一键安装脚本

使用方法：

```
sh install_docker.sh
```

## greenplum相关

- greenplum/analyzeall.sh : greenplum的全库analyze

使用方法：

```
su - gpadmin -l -c 'sh install_docker.sh'
```

- greenplum/dumptables.sh : greenplum的全库表结构备份

使用方法：

```
su - gpadmin -l -c 'sh dumptables.sh'
```

- greenplum/vacuumall.sh : greenplum的全库膨胀清理

使用方法：

```
su - gpadmin -l -c 'sh vacuumall.sh'
```

- greenplum/vacuumtab.sh : greenplum的只进行膨胀表清理

使用方法：

```
su - gpadmin -l -c 'sh vacuumtab.sh'
```

- greenplum/backup_restore/backupall.sh : greenplum的全库备份

使用方法：

```
su - gpadmin -l -c 'sh backupall.sh'
```

- greenplum/backup_restore/restoreall.sh : greenplum的全库恢复

使用方法：

```
su - gpadmin -l -c 'sh restoreall.sh'
```

## system相关

- syste/diskmount.sh : 磁盘一键挂载

使用方法：

```
sh diskmount.sh /dev/sdb /data
```


- syste/update_kernel_to_latest.sh : CentOS7内核一键升级到最新

使用方法：

```
sh update_kernel_to_latest.sh
```



