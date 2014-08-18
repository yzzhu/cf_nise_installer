#!/bin/bash -ex

#执行init，init从stemcell_builder stages中抽取最少的指令来模拟一个类stemcell-like的环境

(
    cd nise_bosh
    sudo ./bin/init
)
