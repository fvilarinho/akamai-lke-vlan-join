# Definition of the linode credentials.
variable "credentials" {
  default = {
    linode = {
      identifier = "<identifier>"
      token      = "<token>"
    }
  }
}

# Definition of the cluster settings.
variable "settings" {
  default = {
    cluster = {
      namespace  = "<namespace>"
      identifier = "<identifier>"
    }
    vlan = {
      identifier  = "<identifier>"
      networkMask = "10.1.0.x/24"
    }
  }
}