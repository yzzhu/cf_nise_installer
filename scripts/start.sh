#!/bin/bash -ex

sudo /var/vcap/bosh/bin/monit
sleep 5

#首先启动psql、nats服务
for process in \
    postgres \
    nats
do
    sudo /var/vcap/bosh/bin/monit start $process
    sleep 30
done;

#启动其它所有模块
sudo /var/vcap/bosh/bin/monit start all

#等待所有进程启动成功
echo "Waiting for all processes to start"
for ((i=0; i < 120; i++)); do
    if ! (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -v -E "running$"); then
        break
    fi
    sleep 10
done

if (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -v -E "running$"); then
    echo "Found process failed to start"
    exit 1
fi

#执行完毕，关闭调试信息，打印结果
set +x
echo "All processes have been started!"
api_url=`grep srv_api_uri: ./manifests/deploy.yml | awk '{ print $2 }'`
password=`grep ' - admin' ./manifests/deploy.yml | cut -f 2 -d '|'  `
echo "Login : 'cf login -a ${api_url} -u admin -p ${password} --skip-ssl-validation'"
echo "Download CF CLI from https://github.com/cloudfoundry/cli"
