#!/bin/bash -e

function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_deps() {
  test -f $(which k0sctl) || error_exit "k0sctl command not detected in path, please install it"
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
}

function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
  eval "$(jq -r '@sh "export MODULE_PATH=\(.module_path)"')"
  [[ -n "${MODULE_PATH}" ]] || error_exit "module_path not found"
}

function run_k0sctl() {
  k0sctl apply -c ${MODULE_PATH}/k0sctl.yaml > ${MODULE_PATH}/k0sctl_log
}

function get_kubeconfig() {
  kubeconfig="$(k0sctl kubeconfig -c ${MODULE_PATH}/k0sctl.yaml)"
  jq -n \
    --arg kubeconfig "${kubeconfig}" \
    '{"kubeconfig": $kubeconfig, "kubeconfig_base64": $kubeconfig | @base64}'
}


check_deps
parse_input
run_k0sctl
get_kubeconfig
