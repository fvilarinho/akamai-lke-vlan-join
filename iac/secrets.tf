# Creates the secrets manifest file. This file contains all the credentials required for the automation.
resource "local_sensitive_file" "secrets" {
  filename = "../etc/secrets.yaml"
  content  = <<EOT
apiVersion: v1
kind: Secret
metadata:
  name: akamai-lke-vlan-join-secrets
  namespace: ${var.settings.cluster.namespace}
type: Opaque
stringData:
  linode-cli: |-
    [DEFAULT]
    default-user = ${var.credentials.linode.identifier}

    [${var.credentials.linode.identifier}]
    token = ${var.credentials.linode.token}
EOT
}

# Applies the secrets manifest in the cluster.
resource "null_resource" "applySecrets" {
  triggers = {
    hash = md5(local_sensitive_file.secrets.filename)
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG        = "../etc/${var.settings.cluster.identifier}-kubeconfig.yaml"
      MANIFEST_FILENAME = local_sensitive_file.secrets.filename
    }

    quiet   = true
    command = "../bin/applyManifest.sh"
  }

  depends_on = [ local_sensitive_file.secrets ]
}