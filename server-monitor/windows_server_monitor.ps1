#!/usr/bin/env powershell

# Windows服务器资源统计脚本
# 统计CPU、内存和硬盘使用情况

# 设置输出编码为UTF-8
# 仅在交互式控制台环境下尝试设置编码
if (-not $PSCommandPath) {
    try {
        [console]::OutputEncoding = [System.Text.Encoding]::UTF8
        Write-Host "控制台编码已设置为UTF-8"
    } catch {
        Write-Host "警告: 无法设置控制台编码"
        Write-Host "错误详情: $_"
    }
} else {
    Write-Host "非交互式运行环境，跳过控制台编码设置"
}

# 获取当前日期时间
$dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "===== 服务器资源使用情况统计 ======="
Write-Host "日期时间: $dateTime"

# 服务器信息
Write-Host "`n===== 服务器信息 ======="
$computerName = $env:COMPUTERNAME
$osInfo = Get-CimInstance Win32_OperatingSystem
$osVersion = $osInfo.Caption + " " + $osInfo.Version
$uptime = (Get-Date) - $osInfo.LastBootUpTime
$uptimeString = "$($uptime.Days) 天, $($uptime.Hours) 小时, $($uptime.Minutes) 分钟"

# 获取IP地址
try {
    $ipAddresses = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -notlike '*Loopback*' } | Select-Object -ExpandProperty IPAddress
} catch {
    $ipAddresses = $null
}

Write-Host "计算机名称: $computerName"
Write-Host "操作系统: $osVersion"
Write-Host "运行时间: $uptimeString"
# 区分内网和外网IP
# 简单判断: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 为内网IP
$internalIPs = @()
$externalIPs = @()

if ($ipAddresses) {
    foreach ($ip in $ipAddresses) {
        if ($ip -match '^10\.' -or $ip -match '^172\.(1[6-9]|2\d|3[01])\.' -or $ip -match '^192\.168\.') {
            $internalIPs += $ip
        } else {
            $externalIPs += $ip
        }
    }
}

Write-Host -NoNewline "内网IP: "
if ($internalIPs) {
    Write-Host $($internalIPs -join ", ")
} else {
    Write-Host "未获取到"
}

Write-Host -NoNewline "外网IP: "
if ($externalIPs) {
    Write-Host $($externalIPs -join ", ")
} else {
    Write-Host "未获取到或无外网连接"
}

# CPU使用情况
Write-Host "`n===== CPU使用情况 ======="
$cpuCores = (Get-CimInstance Win32_Processor).NumberOfLogicalProcessors
Write-Host "CPU逻辑核心数: $cpuCores"

$cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue
if ($cpuUsage) {
    $cpuPercent = [math]::Round($cpuUsage.CounterSamples.CookedValue, 2)
    Write-Host "CPU使用率: $cpuPercent%"
} else {
    Write-Host "无法获取CPU使用率数据"
}

# 内存使用情况
Write-Host "`n===== 内存使用情况 ======="
# TotalVisibleMemorySize和FreePhysicalMemory的单位是KB
$totalMemory = [math]::Round(($osInfo.TotalVisibleMemorySize / 1024) / 1024, 2) # 先转换为MB，再转换为GB
$freeMemory = [math]::Round(($osInfo.FreePhysicalMemory / 1024) / 1024, 2) # 先转换为MB，再转换为GB
$usedMemory = $totalMemory - $freeMemory
$memoryPercent = [math]::Round(($usedMemory / $totalMemory) * 100, 2)

Write-Host "内存总量: $totalMemory GB"
Write-Host "已用内存: $usedMemory GB"
Write-Host "可用内存: $freeMemory GB"
Write-Host "内存使用率: $memoryPercent%"
# 解释: 在Windows中，"可用内存"是指未被任何进程使用的物理内存
Write-Host ""

# 磁盘使用情况
Write-Host "`n===== 磁盘使用情况 ======="
$disks = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
foreach ($disk in $disks) {
    $driveLetter = $disk.DeviceID
    $totalSizeGB = [math]::Round($disk.Size / 1GB, 2)
    $freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $usedSpaceGB = [math]::Round($totalSizeGB - $freeSpaceGB, 2)
    $diskUsage = [math]::Round(($usedSpaceGB / $totalSizeGB) * 100, 2)

    Write-Host "磁盘 ${driveLetter}:" 
    Write-Host "  总容量: $totalSizeGB GB"
    Write-Host "  已用空间: $usedSpaceGB GB"
    Write-Host "  可用空间: $freeSpaceGB GB"
    Write-Host "  使用率: $diskUsage%"
}

Write-Host "`n===== 统计结束 ======="