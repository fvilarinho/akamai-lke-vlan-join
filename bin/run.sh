#!/bin/bash

# Check the dependencies to execute this script.
function checkDependencies() {
  if [ -z "$LINODE_CLI_CMD" ]; then
    echo "Linode CLI is not installed! Please install/setup it first to continue!"

    exit 1
  fi

  if [ -z "$JQ_CMD" ]; then
    echo "JQ is not installed! Please install it first to continue!"

    exit 1
  fi

  if [ -z "$NODE_NAME" ]; then
    echo "The node name is not defined! Please define it first to continue!"

    exit 1
  fi

  if [ -z "$VLAN_NAME" ]; then
    echo "The VLAN name is not defined! Please define it first to continue!"

    exit 1
  fi

  if [ -z "$VLAN_NETWORK_MASK" ]; then
    echo "The VLAN network mask is not defined! Please define it first to continue!"

    exit 1
  fi
}

# Prepare the environment to execute the script.
function prepareToExecute() {
  source functions.sh

  showBanner
}

# Joins the node to the VLAN.
function joinNodeToVlan() {
  echo "- Fetching the details of the node $NODE_NAME..."

  NEEDS_TO_REBOOT=false
  NODE_ID=$(getNodeId $NODE_NAME)
  NODE_INDEX=$(getNodeIndex)

  echo "- Fetching the network configuration of the node $NODE_NAME..."

  NODE_CONFIG_ID=$(getNodeConfigId $NODE_ID)

  ALREADY_HAS_PUBLIC_INTERFACE=$(hasNodePublicInterface $NODE_ID $NODE_CONFIG_ID)

  if [ "$ALREADY_HAS_PUBLIC_INTERFACE" == "false" ]; then
    echo "- Adding the public interface to the node $NODE_NAME..."

    addPublicInterfaceToNode $NODE_ID $NODE_CONFIG_ID

    NEEDS_TO_REBOOT=true
  else
    echo "- The node $NODE_NAME already has a public interface!"
  fi

  ALREADY_HAS_VLAN_INTERFACE=$(hasNodeVlanInterface $NODE_ID $NODE_CONFIG_ID $VLAN_NAME)

  if [ "$ALREADY_HAS_VLAN_INTERFACE" == "false" ]; then
    echo "- Adding the VLAN $VLAN_NAME to the node $NODE_NAME..."

    addVlanInterfaceToNode $NODE_ID $NODE_CONFIG_ID $NODE_INDEX $VLAN_NAME $VLAN_NETWORK_MASK

    NEEDS_TO_REBOOT=true
  else
    echo "- The node $NODE_NAME already has the VLAN $VLAN_NAME!"
  fi

  if [ "$NEEDS_TO_REBOOT" == "true" ]; then
    echo "- Rebooting the node $NODE_NAME to apply the changes..."

    rebootNode $NODE_ID $NODE_CONFIG_ID
  fi
}

# Main functions.
function main() {
  prepareToExecute
  checkDependencies
  joinNodeToVlan
}

main