#!/bin/bash -ex

#若没有设置NISE_IP_ADDRESS，或其值为空，则获取本ip做为NISE_IP_ADDRESS
NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/' | head -n 1`}

#执行generate_deploy_manifest.sh，该脚本根据template.yml生成deploy.yml,deploy.yml为部署时需要的配置文件
./scripts/generate_deploy_manifest.sh

(
    cd nise_bosh
    bundle install

    # Old spec format
    #执行nise_bosh，开始cf部署过程
    # -y 对部署过程中的所有交互都回答yes
    # ../cf-release 指定安装包
    # ../manifests/deploy.yml 指定部署的模版文件
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh -y ../cf-release ../manifests/deploy.yml micro -n ${NISE_IP_ADDRESS}
    # New spec format, keeping the  monit files installed in the previous run
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh --keep-monit-files -y ../cf-release ../manifests/deploy.yml micro_ng -n ${NISE_IP_ADDRESS}
)
