#!/bin/bash
#
#
set -x
echo 添加vagrant用户
if getent passwd vagrant; then
  useradd vagrant
  echo vagrant | passwd vagrant --stdin
fi
echo vagrant | passwd root --stdin

echo 添加vagrant key
mkdir -p ~vagrant/.ssh
cat >>~vagrant/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1YdxBpNlzxDqfJyw/QKow1F+wvG9hXGoqiysfJOn5Y vagrant insecure public key
EOF
chown -R vagrant:vagrant ~vagrant/.ssh
chmod 700 ~vagrant/.ssh
chmod 600 ~vagrant/.ssh/authorized_keys



echo 关闭selinux
setenforce 0
if sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config; then
  echo  重启后生效
fi


echo 安装 guest addition
if ! command -v wget >/dev/null; then
  yum install -y -q wget
fi

if [[ ! -f /tmp/VBoxGuestAdditions_7.0.20.iso ]]; then
  (cd /tmp/ && wget -q https://download.virtualbox.org/virtualbox/7.0.20/VBoxGuestAdditions_7.0.20.iso)
fi

if [[ -w /media ]]; then
  mount /tmp/VBoxGuestAdditions_7.0.20.iso /media
fi

yum install -y -q gcc binutils make perl bzip2 elfutils-libelf-devel
yum install -y -q kernel kernel-devel

/media/VBoxLinuxAdditions.run --nox11
umount /media
rm /tmp/VBoxGuestAdditions_7.0.20.iso
