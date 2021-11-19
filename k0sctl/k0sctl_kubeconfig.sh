#!/bin/bash -e

function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_deps() {
  test -f $(which k0sctl) || error_exit "k0sctl command not detected in path, please install it"
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
  test -f $(which sed) || error_exit "sed command not detected in path, please install it"
}

function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
  eval "$(jq -r '@sh "export PUBLIC_IP=\(.public_ip)"')"
  [[ -n "${PUBLIC_IP}" ]] || error_exit "public_ip not found"
}

function get_kubeconfig() {
  kubeconfig="$(k0sctl kubeconfig -c /tmp/k0sctl.yaml| sed "s/server: https:\/\/.*:/server: https:\/\/${PUBLIC_IP}:/")"
  jq -n \
    --arg kubeconfig "${kubeconfig}" \
    '{"kubeconfig": $kubeconfig, "kubeconfig_base64": $kubeconfig | @base64}'
}


check_deps
parse_input
get_kubeconfig
