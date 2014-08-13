#!/bin/bash -ex

# Detect RVM
# cf的ruby环境采用rbenv管理，如果系统已安装rvm,会提示卸载，卸载后再重新执脚本
if (rvm >/dev/null 2>&1); then
    echo "Found RVM is installed! RVM is not supported by this installer. Remove it and rerun this script."
    exit 1
fi

#更新软件包列表 
sudo apt-get update


#执行intall_ruby.sh脚本，安装ruby相关环境，并使环境变量生效
./scripts/install_ruby.sh
source ~/.profile

#执行clone_nise_bosh.sh脚本，获取nise bosh 源文件
./scripts/clone_nise_bosh.sh

#执行clone_cf_release.sh脚本，获取
./scripts/clone_cf_release.sh

./scripts/install_environemnt.sh
./scripts/install_cf_release.sh

set +x
echo "Done!"
echo "You can launch Cloud Foundry with './scripts/start.sh'"
echo "Restart your server before starting processes if you are using Ubuntu 10.04"
