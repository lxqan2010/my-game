#!/bin/bash

rm -rf ../etc/*

init_config_dir="../init_config/"
if [ ! -d "$init_config_dir" ]; then
	echo "配置启动目录 $init_config_dir 不存在"
	exit 1
fi

env_dir="../etc/"
if [ ! -d "$env_dir" ];then
    mkdir -p $env_dir
fi

env_file=$env_dir"env.lua"
if [ ! -f "$env_file" ]; then
    touch $env_file
fi

echo 'init_config_dir="'$init_config_dir'"' > $env_file
cat $env_file

cp_dir=$init_config_dir"/*"
cmd="cp -R $cp_dir ../etc/"
echo $cmd
eval $cmd

