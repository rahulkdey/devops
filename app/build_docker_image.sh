#!/bin/bash -ex

port=3000
msg="Hello XXX World!"


function print_usage() {
    echo "Usage: $0 port_number message"
}

function to_int {
    local -i num="10#${1}"
    echo "${num}"
}

function port_is_ok {
    retval=""
    local port="$1"
    local -i port_num=$(to_int "${port}" 2>/dev/null)

    if (( $port_num < 1 || $port_num > 65535 )) ; then
        echo "*** ${port} is not a valid port" 1>&2
        retval="false"
    else 
        retval="true"
    fi

    echo "$retval"
}

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

function render_template() {
  eval "echo \"$(cat $1)\""
}

function generate_config_json {
  echo "#### Creating config.json from template ./conf/config.json.tmpl"
  render_template conf/config.json.tmpl > build/config.json
}

mkdir -p build
generate_config_json

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=rahulkdey
# image name
IMAGE=viv-webapp


docker build --build-arg APP_PORT=$port -t $USERNAME/$IMAGE:latest .
echo "All Good"
