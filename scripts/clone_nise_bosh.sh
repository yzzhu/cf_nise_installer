#!/bin/bash -ex

#nise bosh作为一个submodule挂在cf_nise_installer的github项目中，
#clone_nise_bosh.sh这个脚本用于获取nis bos的源文件

if [ ! "$(ls -A nise_bosh)" ]; then
    git submodule update --init --recursive nise_bosh


    (
        cd nise_bosh

        if [ "" != "$NISE_BOSH_REV" ]; then
            git checkout $NISE_BOSH_REV
        fi

        echo "Using Nise BOSH revision: `git rev-list --max-count=1 HEAD`"
    )
else
    echo "'nise_bosh' directory is not empty. Skipping cloning..."
fi
