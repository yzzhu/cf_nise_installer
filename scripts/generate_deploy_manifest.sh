#!/bin/bash -ex

#如果没有指定NISE_IP_ADDRESS，则取本ip为NISE_IP_ADDRESS
NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/' | head -n 1`}

sed "s/192.168.10.10/${NISE_IP_ADDRESS}/g" manifests/template.yml > manifests/deploy.yml

#替换域名
if [ "${NISE_DOMAIN}" != "" ]; then
    if (! sed --version 1>/dev/null 2>&1); then
        # not a GNU sed
        sed -i '' "s/${NISE_IP_ADDRESS}.xip.io/${NISE_DOMAIN}/g" manifests/deploy.yml
    else
        sed -i "s/${NISE_IP_ADDRESS}.xip.io/${NISE_DOMAIN}/g" manifests/deploy.yml
    fi
fi

#替换密码
if [ "${NISE_PASSWORD}" != "" ]; then
    if (! sed --version 1>/dev/null 2>&1); then
        # not a GNU sed
        sed -i '' "s/c1oudc0w/${NISE_PASSWORD}/g" manifests/deploy.yml
    else
        sed -i "s/c1oudc0w/${NISE_PASSWORD}/g" manifests/deploy.yml
    fi
fi
