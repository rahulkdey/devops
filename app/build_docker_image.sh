#!/bin/bash -ex

. ./build_common.sh

if [ $# -gt 2 ]
then
    print_usage
    exit 1
fi

if [ $# -eq 2 ]
then
    port=$1
    msg=\"$2\"
fi

if [ $# -eq 1 ]
then
    port=$1
fi

retval=$(port_is_ok "${port}")
if [ "$retval" == "false" ]
then
    print_usage
    exit 1
fi

mkdir -p build
generate_config_json

docker build --build-arg APP_PORT=$port -t $USERNAME/$IMAGE:latest .

eval "echo '[{\"name\":\"$IMAGE:latest\",\"imageUri\":\"$USERNAME/$IMAGE:latest\"}]'" > imagedefinitions.json
#echo $image_def  > imagedefinitions.json
echo "All Good"
