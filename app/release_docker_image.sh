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

# ensure we're up to date
git pull


# bump version
version=`cat VERSION`
echo "version: $version"

# run build
./build_docker_image.sh $*

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags
docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version

# push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version

echo "All Good"
