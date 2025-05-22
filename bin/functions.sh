#!/bin/bash

# Prepare the environment to run this script.
function prepareToExecute() {
  export JQ_CMD=$(which jq)
  export LINODE_CLI_CMD=$(which linode-cli)
}

# Show the banner.
function showBanner() {
  if [ -e "$ETC_DIR/banner.txt" ]; then
    cat "$ETC_DIR/banner.txt"
  fi
}

function getNodeId() {
  NODE_NAME=$1

  NODE_ID=$($LINODE_CLI_CMD --text --no-header --format linodes list --label "$NODE_NAME")
}

function getNodeIndex() {
  echo $(hostname -i | awk -F'.' '{print $4}')
}

# Get the node network configurations.
# Receive as argument the node identifier.
function getNodeConfigId() {
  NODE_ID=$1

  if [ -z "$NODE_ID" ]; then
    echo "The node not defined! It's not possible to find its configuration!"

    exit 1
  fi

  echo $($LINODE_CLI_CMD --suppress-warnings \
                         linodes \
                         configs-list \
                         $NODE_ID --json | $JQ_CMD -r ".[]|select(.label == \"Boot Config\")|.id")
}

# Check if the node already has the public interface.
# Receive as argument the node and configuration identifiers.
function hasNodePublicInterface() {
  NODE_ID=$1
  NODE_CONFIG_ID=$2
  RESULT=$($LINODE_CLI_CMD --suppress-warnings \
                           linodes \
                           config-interfaces-list \
                           $NODE_ID \
                           $NODE_CONFIG_ID \
                           --json | $JQ_CMD -r ".[]|select(.purpose == \"public\")|.id")

  if [ -z "$RESULT" ]; then
    echo false
  else
    echo true
  fi
}

# Check if the node already has the VLAN interface.
# Receive as argument the node and configuration identifiers, and the VLAN name.
function hasNodeVlanInterface() {
  NODE_ID=$1
  NODE_CONFIG_ID=$2
  VLAN_NAME=$3
  RESULT=$($LINODE_CLI_CMD --suppress-warnings \
                           linodes \
                           config-interfaces-list \
                           $NODE_ID \
                           $NODE_CONFIG_ID \
                           --json | $JQ_CMD -r ".[]|select(.label == \"$VLAN_NAME\")|.id")

  if [ -z "$RESULT" ]; then
    echo false
  else
    echo true
  fi
}

# Add the public interface to the node.
# Receive as argument the node and configuration identifiers.
function addPublicInterfaceToNode() {
  $LINODE_CLI_CMD --suppress-warnings \
                  linodes \
                  config-interface-add \
                  --primary true \
                  --purpose public \
                  $NODE_ID \
                  $NODE_CONFIG_ID > /dev/null
}

# Add the public interface to the node.
# Receive as argument the node and configuration identifiers, the VLAN name and network mask.
function addVlanInterfaceToNode() {
  VLAN_NAME=$4
  VLAN_NETWORK_MASK=$5
  NODE_ID=$1
  NODE_CONFIG_ID=$2
  NODE_INDEX=$3
  NODE_IP=$(echo "$VLAN_NETWORK_MASK" | sed 's|.x|.'"$NODE_INDEX"'|g')

  $LINODE_CLI_CMD --suppress-warnings \
                  linodes \
                  config-interface-add \
                  --label $VLAN_NAME \
                  --purpose vlan \
                  --ipam_address $NODE_IP \
                  $NODE_ID \
                  $NODE_CONFIG_ID > /dev/null
}

# Reboot the node to apply the changes.
# Receive as argument the node and configuration identifiers.
function rebootNode() {
  NODE_ID=$1
  NODE_CONFIG_ID=$2

  $LINODE_CLI_CMD --suppress-warnings \
                  linodes \
                  reboot \
                  --config_id $NODE_CONFIG_ID \
                  $NODE_ID > /dev/null
}

prepareToExecute
}