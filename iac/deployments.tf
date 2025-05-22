# Creates the deployments manifest file. This file contains the definition to run the automation.
resource "local_sensitive_file" "deployments" {
  filename = "../etc/deployments.yaml"
  content  = <<EOT
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: akamai-lke-vlan-join
  namespace: ${var.settings.cluster.namespace}
spec:
  selector:
    matchLabels:
      app: akamai-lke-vlan-join
  template:
    metadata:
      labels:
        app: akamai-lke-vlan-join
    spec:
      containers:
        - name: akamai-lke-vlan-join
          image: ghcr.io/fvilarinho/akamai-lke-vlan-join:latest
          env:
            - name: NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: VLAN_NAME
              value: "${var.settings.vlan.identifier}"
            - name: VLAN_NETWORK_MASK
              value: "${var.settings.vlan.networkMask}"
          volumeMounts:
            - name: akamai-lke-vlan-join-secrets
              mountPath: /home/akamai-lke-vlan-join/.config/linode-cli
              subPath: linode-cli
      volumes:
        - name: akamai-lke-vlan-join-secrets
          secret:
            secretName: akamai-lke-vlan-join-secrets
EOT
}

# Applies the deployments manifest in the cluster.
resource "null_resource" "applyDeployments" {
  triggers = {
    hash = md5(local_sensitive_file.deployments.filename)
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG        = "../etc/${var.settings.cluster.identifier}-kubeconfig.yaml"
      MANIFEST_FILENAME = local_sensitive_file.secrets.filename
    }

    quiet   = true
    command = "../bin/applyManifest.sh"
  }

  depends_on = [
    local_sensitive_file.deployments,
    null_resource.applySecrets
  ]
}