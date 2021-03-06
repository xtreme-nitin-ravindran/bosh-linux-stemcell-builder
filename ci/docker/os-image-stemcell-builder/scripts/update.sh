#!/bin/bash

set -ex

cat > /etc/apt/sources.list <<EOS
deb http://us.archive.ubuntu.com/ubuntu/ xenial main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main restricted

deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates main restricted

deb http://security.ubuntu.com/ubuntu xenial-security main restricted
deb-src http://security.ubuntu.com/ubuntu xenial-security main restricted
deb http://security.ubuntu.com/ubuntu xenial-security universe
deb-src http://security.ubuntu.com/ubuntu xenial-security universe
deb http://security.ubuntu.com/ubuntu xenial-security multiverse
deb-src http://security.ubuntu.com/ubuntu xenial-security multiverse

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://us.archive.ubuntu.com/ubuntu/ xenial universe
deb-src http://us.archive.ubuntu.com/ubuntu/ xenial universe
deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates universe
deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates universe
deb http://us.archive.ubuntu.com/ubuntu/ xenial multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ xenial multiverse
deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates multiverse
EOS

apt-get update
apt-get -y upgrade; apt-get clean

DEBIAN_FRONTEND=noninteractive apt-get -y  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get -y install curl

# sometimes the cached lists seem to get out of date around here
# http://askubuntu.com/questions/41605/trouble-downloading-packages-list-due-to-a-hash-sum-mismatch-error/160179
rm -rf /var/lib/apt/lists/*

apt-get -y update --fix-missing
apt-get -y install git
apt-get -y install build-essential

# ensure the correct kernel headers are installed
apt-get -y install linux-headers-generic

# stemcell image creation
apt-get -y install udev dmsetup debootstrap kpartx

# stemcell uploading
apt-get -y install s3cmd

# native gem compilation
apt-get -y install g++ git-core make

# native gem dependencies
apt-get -y install libmysqlclient-dev libpq-dev libsqlite3-dev libxml2-dev libxslt-dev

# vSphere requirements
apt-get -y install open-vm-tools

# OpenStack requirement
apt-get -y install qemu-utils

# needed by stemcell building
apt-get -y install parted

# needed by stemcell building to debug issue in kpartx/parted
apt-get -y install lsof

yes N | apt-get -y install sudo

mkdir -p /mnt/tmp
chown -R ubuntu:ubuntu /mnt/tmp
echo 'export TMPDIR=/mnt/tmp' >> ~ubuntu/.bashrc

# rake tasks will be using this as chroot
mkdir -p /mnt/stemcells
chown -R ubuntu:ubuntu /mnt/stemcells
