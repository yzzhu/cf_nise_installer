#!/bin/bash -ex

#判断系统是否是64位系统
if [ ! -f /etc/lsb-release ] || \
   [ `uname -m` != "x86_64" ]; then
    echo "This installer supports only Ubuntu 10.04 and 12.04 64bit server"
    exit 1;
fi

#检测系统是否已经安装了git,若没有安装则安装git
# Git bootstrap
if ! (which git); then
    sudo apt-get update
    sudo apt-get install -y git-core
fi


#设置cf_nise_installer的git地址及版本分支
INSTALLER_URL=${INSTALLER_URL:-https://github.com/yudai/cf_nise_installer.git}
INSTALLER_BRANCH=${INSTALLER_BRANCH:-master}

#clone cf_nise_installer
if [ ! -d cf_nise_installer ]; then
    git clone ${INSTALLER_URL} cf_nise_installer
fi

#检出master分支，执行install脚本
(
    cd cf_nise_installer
    git checkout ${INSTALLER_BRANCH}
    ./scripts/install.sh
)
