#!/bin/bash -ex

#cf release作为一个submodule挂在cf_nise_installer的github项目中，
#clone_cf_release.sh这个脚本用于获取cf release的源文件

CF_RELEASE_USE_HEAD=${CF_RELEASE_USE_HEAD:-no}

ruby_version=`rbenv version | cut -f1 -d" "` # to overwrite .ruby-version

if [ ! "$(ls -A cf-release)" ]; then
    # 根据是否设置了CF_RELEASE_URL来完成不同的动作，可直接在脚本开始处设置变量或者设置系环境变量达到改变执行流程的目的
    if [ -z "${CF_RELEASE_URL}" ]; then
        git submodule update --init cf-release
    else
        rmdir cf-release
        git clone ${CF_RELEASE_URL} cf-release
    fi

    (
        cd cf-release
        #判断是否设置了分支版本
        if [ -n "${CF_RELEASE_BRANCH}" ]; then
            git checkout -f ${CF_RELEASE_BRANCH}
        fi

        if [ $CF_RELEASE_USE_HEAD != "no" ]; then
        #通过设置CF_RELEASE_USE_HEAD=yes,可以使安装的为最新版本的cf
            # required to compile a gem native extension of CCNG
            sudo apt-get -y install git-core libmysqlclient-dev libpq-dev libsqlite3-dev libxml2-dev libxslt-dev
            gem install rake -v 0.9.2.2 --no-rdoc --no-ri # hack for collector

            git submodule update --init --recursive
            RBENV_VERSION=$ruby_version bundle install
            RBENV_VERSION=$ruby_version bundle exec bosh -n create release --force
        fi
    )
else
    echo "'cf-release' directory is not empty. Skipping cloning..."
fi
