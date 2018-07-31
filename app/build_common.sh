#!/bin/bash -ex

# docker hub username
USERNAME=rahulkdey
# image name
IMAGE=viv-webapp

#Default port number and msg
port=3000
msg="Hello XXX World!"

function print_usage() {
    echo "Usage: $0 port_number message"
}

function to_int() {
    local -i num="10#${1}"
    echo "${num}"
}

function port_is_ok() {
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

function render_template() {
  eval "echo \"$(cat $1)\""
}

function generate_config_json() {
  echo "#### Creating config.json from template ./conf/config.json.tmpl"
  render_template conf/config.json.tmpl > build/config.json
}

