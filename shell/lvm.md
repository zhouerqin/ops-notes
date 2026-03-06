# LVM (Logical Volume Management)

## LVM 架构
```mermaid
graph TD
subgraph 物理设备
    /dev/sdb1
    /dev/sdc1
    /dev/sdd1
end
subgraph 物理卷 PV
    /dev/sdb1-->|create| PV1
    /dev/sdc1-->|create| PV2
    /dev/sdd1-->|create| PV3
end
subgraph 卷组 VG
    PV1-->|create| VG1[centos]
    PV2-->|extend| VG1
    PV3-->|extend| VG1
end
subgraph 逻辑卷 LV
    VG1-->|create| LV1[/root]
    VG1-->|create| LV2[/home]
end
```

## LVM 组件详解

### 物理卷 (Physical Volume - PV)
- **定义**：物理存储设备的逻辑表示
- **类型**：磁盘分区、磁盘、RAID 设备、LUN 等
- **特性**：可以叠加使用，支持动态调整

### 卷组 (Volume Group - VG)  
- **定义**：一个或多个 PV 的集合
- **作用**：为逻辑卷提供统一的存储池
- **特性**：PV 可以动态增减

### 逻辑卷 (Logical Volume - LV)
- **定义**：VG 中分配的虚拟存储空间
- **特性**：可以动态调整大小，跨多个 PV

## 详细操作指南

### 1. 物理卷 (PV) 管理
```bash
# 创建 PV
pvcreate /dev/sdb1                     # 基本创建
pvcreate -f /dev/sdc1                  # 强制创建（可能覆盖数据）
pvcreate -v /dev/sdd1                  # 详细输出模式
pvcreate --metadatacopies 2 /dev/sde1  # 设置元数据副本数量

# 查看 PV 信息
pvscan                                    # 扫描所有 PV
pvscan --cache                           # 使用缓存
pvdisplay /dev/sdb1                      # 详细显示单个 PV 信息
pvdisplay -v /dev/sdb1                   # 详细显示模式
pvdisplay -c /dev/sdb1                   # CSV 输出格式

# PV 状态信息
pvck /dev/sdb1                          # 检查 PV 一致性
pvchange -x n /dev/sdb1                 # 禁用 PV 的分配
pvchange -x y /dev/sdb1                 # 启用 PV 的分配
pvchange -aay /dev/sdb1                # 启用所有 PV 的分配

# 移除 PV（注意：数据会丢失）
pvremove /dev/sdb1

# 扩展 PV（必须先将空间添加到 VG）
pvresize /dev/sdb1                      # 调整 PV 大小以匹配底层设备
```

### 2. 卷组 (VG) 管理
```bash
# 创建 VG
vgcreate myvg /dev/sdb1                 # 基本 VG 创建
vgcreate -s 32M myvg /dev/sdb1         # 设置物理扩展大小
vgcreate -l 256 myvg /dev/sdb1         # 设置逻辑扩展数量
vgcreate -p 16 myvg /dev/sdb1          # 设置最大 PV 数量
vgcreate -v myvg /dev/sdb1             # 详细输出模式

# 查看 VG 信息
vgscan                                    # 扫描所有 VG
vgdisplay myvg                          # 显示 VG 详细信息
vgdisplay -v myvg                       # 详细显示模式
vgdisplay -c myvg                       # CSV 输出格式
vgdisplay -o +size,free myvg            # 显示特定属性

# VG 属性和配置
vgchange -a y myvg                     # 激活 VG
vgchange -a n myvg                     # 停用 VG
vgchange -an myvg                      # 关闭 VG 的自动激活
vgchange -ay myvg                      # 打开 VG 的自动激活

# VG 信息查看
vgreduce /dev/sdb1 myvg                # 从 VG 中移除 PV（注意数据安全）
vgreduce -a myvg                       # 移除所有空的 PV
vgreduce -f myvg                       # 强制移除 PV（可能导致数据丢失）

# VG 元数据管理
vgcfgbackup -f backupfile myvg         # 备份 VG 配置
vgcfgrestore -f backupfile myvg        # 从备份恢复 VG 配置
vgcfgbackup -f - myvg                  # 备份到标准输出

# 扩展 VG
vgextend myvg /dev/sdc1                # 添加新 PV 到现有 VG
vgextend -l 256 myvg /dev/sdc1        # 指定逻辑扩展数
vgextend -s 32M myvg /dev/sdc1         # 指定物理扩展大小

# 缩小 VG（谨慎操作）
vgreduce /dev/sdb1 myvg                # 从 VG 中移除 PV
vgreduce -r myvg                       # 移除后重新调整 LV
vgreduce -f myvg                       # 强制移除

# VG 删除（数据会丢失）
vgremove myvg                           # 删除 VG
vgremove -f myvg                       # 强制删除

# 修改 VG 属性
vgchange -s 16M myvg                   # 修改物理扩展大小
vgchange -p 32 myvg                    # 修改最大 PV 数量
```

### 3. 逻辑卷 (LV) 管理
```bash
# 创建 LV
lvcreate -L 10G -n mylv myvg          # 创建 10GB 的 LV
lvcreate -l 512 -n mylv myvg         # 创建 512 个逻辑扩展的 LV
lvcreate -L 100%FREE -n mylv myvg    # 使用 VG 中所有剩余空间
lvcreate -i 4 -I 256K -n mylv myvg   # 设置条带化
lvcreate -m 1 -n mylv myvg           # 创建镜像 LV
lvcreate -r -n mylv myvg             # 创建 RAID LV

# 查看 LV 信息
lvscan                                  # 扫描所有 LV
lvdisplay myvg/mylv                   # 显示 LV 详细信息
lvdisplay -v myvg/mylv                # 详细显示模式
lvdisplay -c myvg/mylv                # CSV 输出格式
lvs myvg                               # 显示 LV 列表信息
lvdisplay -o +uuid,mytag myvg/mylv   # 显示特定属性

# LV 扩容
# XFS 文件系统
lvextend -L +5G /dev/myvg/mylv       # 增加 5GB
lvextend -l +100%FREE /dev/myvg/mylv  # 使用所有剩余空间
xfs_growfs /mnt/mylv                  # 扩展 XFS 文件系统

# EXT4 文件系统
lvextend -L +10G /dev/myvg/mylv       # 增加 10GB
resize2fs /dev/myvg/mylv             # 扩展文件系统

# 立即扩容（某些系统支持）
lvextend -L +20G -r /dev/myvg/mylv   # 立即扩展文件系统

# LV 缩容（谨慎操作）
# EXT4 文件系统
umount /mnt/mylv                      # 先卸载
resize2fs /dev/myvg/mylv 5G           # 缩小文件系统到 5GB
lvreduce -L 5G /dev/myvg/mylv         # 缩小逻辑卷到 5GB
mount /mnt/mylv                       # 重新挂载

# XFS 文件系统（需要先卸载）
umount /mnt/mylv
lvreduce -L 5G /dev/myvg/mylv         # 直接缩小逻辑卷
xfs_growfs /dev/myvg/mylv            # XFS 不支持缩小，需要重建

# LV 重命名
lvrename myvg/mylv myvg/newlv         # 重命名 LV

# LV 删除
lvremove /dev/myvg/mylv               # 删除 LV
lvremove -f /dev/myvg/mylv           # 强制删除

# LV 条带化（RAID 0）
lvcreate -i 2 -I 64K -n stripedLV myvg  # 创建 2 条带，64K 条带大小
lvcreate -i 4 -n myvg/stripedLV      # 使用默认条带大小

# LV 镜像（RAID 1）
lvcreate -m 1 -n mirrorLV myvg       # 创建 1 镜像（总共 2 副本）
lvcreate -m 1 -l 1024 -n mirrorLV myvg # 指定大小
```

### 4. 高级 LVM 操作

#### 快照管理
```bash
# 创建快照
lvcreate -L 1G -s -n mylvsnap /dev/myvg/mylv
lvcreate -L 10%ORIGIN -s -n mylvsnap /dev/myvg/mylv

# 查看快照
lvdisplay /dev/myvg/mylvsnap
lvs -o +snap_percent /dev/myvg/mylvsnap

# 合并快照
lvconvert --merge /dev/myvg/mylvsnap

# 删除快照
lvremove /dev/myvg/mylvsnap
```

#### RAID 配置
```bash
# RAID 0 (条带化)
lvcreate -i 2 -n raid0lv -l 1024 myvg

# RAID 1 (镜像)
lvcreate -m 1 -n raid1lv -l 1024 myvg

# RAID 5
lvcreate -i 3 -I 64K -n raid5lv -l 1024 myvg

# RAID 6
lvcreate -i 3 -n raid6lv -l 1024 myvg

# 查看 RAID 卷
lvs -o +raid_mismatch_count,raid_sync_action
```

#### 薄配置 (Thin Provisioning)
```bash
# 创建薄池
lvcreate -L 10G -T -n mypool myvg

# 创建薄卷
lvcreate -V 5G -T -n thinlv myvg/mypool
lvcreate -V 1G -T -V 500M myvg/mypool  # 限制最大大小

# 自动精简配置
lvcreate -V 5G -T -n thinlv --thinpool myvg/mypool

# 查看薄卷
lvs -o +lv_thin,lv_thin_pool
```

### 5. LVM 监控和故障排除

#### 监控工具
```bash
# 实时监控
dmsetup info                            # 显示映射设备信息
dmsetup table                           # 显示映射表
dmsetup status                          # 显示设备状态

# LVM 统计
pvdisplay /dev/sdb1 -v                 # 详细 PV 信息
vgdisplay myvg -v                      # 详细 VG 信息
lvdisplay myvg/mylv -v                 # 详细 LV 信息
vgs myvg                               # 简化 VG 信息
lvs myvg                               # 简化 LV 信息
pvs /dev/sdb1                          # 简化 PV 信息

# 日志查看
journalctl -u lvm2-monitor.service      # 查看 LVM 监控服务日志
journalctl -u lvm2-lvmetad.service     # 查看 LVM 后端服务日志
```

#### 故障排除
```bash
# 检查 LVM 一致性
pvck /dev/sdb1                         # 检查 PV 一致性
vgck myvg                              # 检查 VG 一致性
lvck /dev/myvg/mylv                    # 检查 LV 一致性

# 重建配置
pvscan --cache                         # 重建 PV 缓存
vgscan                                 # 重建 VG 配置
lvscan                                 # 扫描并激活 LV

# 恢复 VG 配置
vgcfgrestore myvg                      # 恢复 VG 配置
vgcfgrestore /dev/sdb1                  # 恢复 PV 配置

# 手动激活/停用
vgchange -ay myvg                      # 激活 VG
vgchange -an myvg                      # 停用 VG
lvchange -ay /dev/myvg/mylv           # 激活单个 LV
lvchange -an /dev/myvg/mylv            # 停用单个 LV
```

### 6. 实用脚本示例

#### 自动扩容脚本
```bash
#!/bin/bash
# 自动扩展逻辑卷脚本

VG_NAME="myvg"
LV_NAME="datalv"
TARGET_SIZE="20G"

# 检查 VG 中可用空间
FREE_SPACE=$(vgdisplay "$VG_NAME" | grep "Free" | awk '{print $5}' | sed 's/[^0-9]//g')
if [ "$FREE_SPACE" -lt 20 ]; then
    echo "错误: VG中没有足够空间进行扩容"
    exit 1
fi

# 扩容 LV
lvextend -L "$TARGET_SIZE" /dev/"$VG_NAME"/"$LV_NAME"

# 根据文件系统类型调整大小
FS_TYPE=$(lsblk -no FSTYPE /dev/"$VG_NAME"/"$LV_NAME")
case $FS_TYPE in
    xfs)
        xfs_growfs /mnt/"$LV_NAME"
        ;;
    ext4|ext3|ext2)
        resize2fs /dev/"$VG_NAME"/"$LV_NAME"
        ;;
    *)
        echo "不支持的文件系统类型: $FS_TYPE"
        exit 1
        ;;
esac

echo "扩容完成: $VG_NAME/$LV_NAME -> $TARGET_SIZE"
```

#### 磁盘空间分析脚本
```bash
#!/bin/bash
# LVM 空间使用分析脚本

echo "=== LVM 空间使用分析 ==="
echo

# 显示 VG 总览
echo "卷组总览:"
vgs --units G --noheadings | while read vg size free used; do
    echo "VG: $vg | 总大小: $size | 可用: $free | 使用: $used"
done
echo

# 显示 LV 详情
echo "逻辑卷详情:"
lvs -o vg_name,lv_name,lv_size,lv_attr,lv_path --units G --noheadings | while read vg lv size attr path; do
    # 计算使用率（简化版本）
    echo "LV: $vg/$lv | 大小: $size | 属性: $attr | 路径: $path"
done

echo
echo "=== 空间使用情况 ==="
lvs -o vg_name,lv_name,lv_size,lv_free --units G --noheadings
```

## 常见错误和解决方案

### 常见错误
1. **PV 状态不可用**
   ```
   解决: pvck /dev/sdb1 检查一致性
   ```

2. **VG 无法激活**
   ```
   解决: vgchange -ay myvg
   检查: journalctl -u lvm2-monitor.service
   ```

3. **LV 扩容失败**
   ```
   解决: 确保有足够的 PV 空间
            检查文件系统类型和扩容命令
   ```

4. **快照空间不足**
   ```
   解决: 删除不需要的快照
           增加快照池大小
   ```

## 最佳实践
1. **规划空间**: 预留足够的 PV 空间
2. **监控使用率**: 定期检查 VG 空间使用情况
3. **备份配置**: 定期备份 VG 配置
4. **测试操作**: 在生产环境前先在测试环境验证
5. **文档记录**: 记录所有 LVM 操作历史

## 参考文档
- LVM HOWTO：<https://tldp.org/HOWTO/LVM-HOWTO/>
- Red Hat LVM 管理：<https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_logical_volumes/index>
- Arch Linux LVM Wiki：<https://wiki.archlinux.org/title/LVM>
