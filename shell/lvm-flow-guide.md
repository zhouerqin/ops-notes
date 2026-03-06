# LVM 操作流程对应指南

## 对应流程图的操作步骤

### 1. 物理设备 → 物理卷 (PV)
```bash
# 步骤1: 创建物理卷 (对应流程图中的 PV1、PV2、PV3)
pvcreate /dev/sdb1                     # 创建物理卷1
pvcreate /dev/sdc1                     # 创建物理卷2  
pvcreate /dev/sdd1                     # 创建物理卷3

# 验证创建结果
pvscan                                  # 扫描所有PV
pvdisplay /dev/sdb1                    # 显示详细信息
```

### 2. 物理卷 → 卷组 (VG)
```bash
# 步骤2: 创建卷组 (对应流程图中的 VG1)
vgcreate centos /dev/sdb1              # 使用第一个PV创建卷组

# 步骤3: 扩展卷组 (对应流程图中的 PV2、PV3 加入 VG1)
vgextend centos /dev/sdc1              # 添加第二个PV到VG
vgextend centos /dev/sdd1              # 添加第三个PV到VG

# 验证VG创建和扩展
vgdisplay centos                       # 显示VG详细信息
vgs                                     # 简化显示VG信息
```

### 3. 卷组 → 逻辑卷 (LV)
```bash
# 步骤4: 创建逻辑卷 (对应流程图中的 LV1、LV2)
lvcreate -L 20G -n root centos          # 创建root卷 (LV1)
lvcreate -L 50G -n home centos          # 创建home卷 (LV2)

# 验证LV创建
lvdisplay /dev/centos/root             # 显示root卷信息
lvdisplay /dev/centos/home             # 显示home卷信息
lvs                                     # 简化显示LV信息
```

### 4. 扩容操作（按照流程图）
```bash
# 扩容VG（添加新的物理设备）
pvcreate /dev/sde1                     # 创建新的物理卷
vgextend centos /dev/sde1              # 扩展卷组

# 扩容LV和文件系统
## EXT4 文件系统扩容
lvextend -L +30G /dev/centos/home      # 扩容逻辑卷
resize2fs /dev/centos/home             # 扩容文件系统

## XFS 文件系统扩容
lvextend -L +40G /dev/centos/home      # 扩容逻辑卷
xfs_growfs /dev/centos/home           # 扩容文件系统
```

## 扩容后的验证
```bash
# 查看最终结果
vgdisplay centos                       # 查看VG总大小
lvdisplay /dev/centos/home             # 查看LV大小
df -h /home                            # 查看文件系统使用情况
```

## 完整操作流程总结

1. **物理设备准备**: `/dev/sdb1`, `/dev/sdc1`, `/dev/sdd1`
2. **创建PV**: `pvcreate` 命令
3. **创建VG**: `vgcreate` 命令  
4. **扩展VG**: `vgextend` 命令
5. **创建LV**: `lvcreate` 命令
6. **扩容操作**: `lvextend` + 文件系统扩容命令
7. **验证结果**: 各种 `display` 命令