```text
    _   _                   _
   /_\ | |____ _ _ __  __ _(_)
  / _ \| / / _` | '  \/ _` | |
 /_/ \_\_\_\__,_|_|_|_\__,_|_|
  _    _  _____   __   ___      _   _  _
 | |  | |/ / __|  \ \ / / |    /_\ | \| |
 | |__| ' <| _|    \ V /| |__ / _ \| .` |
 |____|_|\_\___|    \_/ |____/_/ \_\_|\_|
                                                 _   _
  _ | |___(_)_ _     /_\ _  _| |_ ___ _ __  __ _| |_(_)___ _ _
 | || / _ \ | ' \   / _ \ || |  _/ _ \ '  \/ _` |  _| / _ \ ' \
  \__/\___/_|_||_| /_/ \_\_,_|\__\___/_|_|_\__,_|\__|_\___/_||_|

```

## 1. Introduction
Customers often need to secure their infrastructure against both internal and external access. The recommended approach 
is to use VLANs or VPCs to isolate traffic to and from cluster nodes. However, Akamai currently does not support 
built-in VLANs or VPCs in the Linode Kubernetes Engine (LKE). This feature is planned for release in the LKE Enterprise 
offering in late 2025.

Meanwhile, you can isolate the LKE cluster, automating the attachment of a VLAN in the nodes using this project.

## 2. Maintainers
- [Felipe Vilarinho](https://www.linkedin.com/in/fvilarinho)

If you're interested in collaborating on this project, feel free to reach out to us via email.

Since this project is open-source, you can also fork and customize it on your own. Follow the requirements below to 
set up your build environment.

### Latest build status
- [![Akamai Secure LKE Pipeline](https://github.com/fvilarinho/akamai-secure-lke/actions/workflows/pipeline.yml/badge.svg)](https://github.com/fvilarinho/akamai-secure-lke/actions/workflows/pipeline.yml)

## 3. Architecture
The automation is consisted in 3 Kubernetes resources:

2. Secrets: Responsible to define the credentials to run the automation. Please check the file `iac/secrets.tf'.
3. DaemonSet: Responsible to execute the automation. Please check the file `iac/deployments.tf'.

## 4. Requirements

### Packaging and Publishing
The container image used to execute the automation was custom-built with the following:

- [Alpine Linux](https://alpinelinux.org/) - Base OS.
- [net-tools](https://pkgs.alpinelinux.org/package/edge/main/x86/net-tools) - Networking toolkit.
- [bind-tools](https://pkgs.alpinelinux.org/package/edge/main/x86/bind-tools) - DNS toolkit.
- [bash](https://www.gnu.org/software/bash/) - Linux shell used to execute the automation.
- [jq](https://jqlang.org/) - JSON parser tool.
- [Python3 and PIP](https://www.python.org/downloads/) - Dependency of Linode CLI.
- [Linode CLI](https://github.com/linode/linode-cli) - CLI to orchestrate/provision resources in Akamai Cloud Computing.

The following software must be installed in the environment to package and publish the container image:

- [Docker 24.x or later](https://www.docker.com)
- `Any linux distribution with Kernel 5.x or later` or
- `MacOS Catalina or later` or
- `MS-Windows 10 or later with WSL2`

Please check more details in files `etc/docker-compose.yaml` and `etc/Dockerfile`.

Just execute the script below to start the packaging using the environment variables specified in the `.env` file:
```bash
./package.sh
```  

Just execute the script below to start the publishing using the environment variables specified in the `.env` file:
```bash
./publish.sh
```  
Here, you will need an additional environment variable called `DOCKER_REGISTRY_PASSWORD` that will contain the 
credentials to store the built image in the Docker Registry.

***PLEASE DON'T COMMIT ANY CREDENTIALS OR SENSITIVE INFORMATION IN THE PROJECT!***

### Deployment
The following software must be installed in the environment to deploy the automation in a LKE cluster:

- [terraform](https://terraform.io/) - IaC tool.
- [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) - Kubernetes CLI.
- `Any linux distribution with Kernel 5.x or later` or
- `MacOS Catalina or later` or
- `MS-Windows 10 or later with WSL2`

Just execute the script below to start the deployment using the attributes specified in the `iac/variables.tf` or 
`iac/terraform.tfvars` file:
```bash
./deploy.sh
```
After provisioning, you'll see that a firewall with the identifier of the cluster was created with the default rules to
block unwanted access from public and private network. 

## 5. Other resources
- [Akamai Techdocs](https://techdocs.akamai.com)
- [Akamai Connected Cloud](https://www.linode.com)

And that’s it! Enjoy!