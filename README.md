## Akamai LKE VLAN Join

### Introduction
This automation joins the nodes of a LKE cluster in a VLAN for internal communication between services/applications.

### Requirements
To run this automation, you will need:
- [linode-cli 5.56.x](https://github.com/linode/linode-cli)
- [jq 1.7.x](https://jqlang.org/)
- MacOS Catalina (or later) or
- Windows 10 (or later) with WSL2 or
- Any Linux distribution

After your environment is set, please define the settings to run the automation in `etc/settings.json`.
You will need to define the cluster name, the vlan name and the vlan network mask.
The network must be defined as following:

- 10.1.0.x/24

Where the `x` will be replaced with the cluster node index starting with 2.

After your settings is defined, just run the script `run.sh` in the root directory.


