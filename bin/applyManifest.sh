#!/bin/bash

# Checks the dependencies of this script.
function checkDependencies() {
  if [ -z "$KUBECTL_CMD" ]; then
    echo "kubectl is not installed!"

    exit 1
  fi

  if [ -z "$KUBECONFIG" ]; then
    echo "kubeconfig is not defined!"

    exit 1
  fi

  if [ ! -f "$KUBECONFIG" ]; then
    echo "kubeconfig was not found!"

    exit 1
  fi
}

# Prepares the environment to execute this script.
function prepareToExecute() {
  source ../functions.sh
}

# Applies the resources required by the automation.
function apply() {
  if [ -n "$MANIFEST_FILENAME" ] && [ -f "$MANIFEST_FILENAME" ]; then
    $KUBECTL_CMD apply -f "$MANIFEST_FILENAME"
  fi
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  apply
}

main