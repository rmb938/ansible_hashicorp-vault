# {{ ansible_managed }}

ui            = true
cluster_addr  = "https://{{ inventory_hostname }}:8201"
api_addr      = "https://{{ inventory_hostname }}:8200"
disable_mlock = false

default_lease_ttl = "7d"

storage "gcs" {
  bucket     = "rmb-lab-hashicorp-vault"
  ha_enabled = "true"
}

seal "gcpckms" {
  project     = "rmb-lab"
  region      = "global"
  key_ring    = "hashicorp-vault"
  crypto_key  = "hashicorp-vault"
}

listener "tcp" {
  address = "{% raw %}{{ GetInterfaceIP \"tailscale0\" }}{% endraw %}:8200"

  tls_cert_file      = "/opt/vault/tls/{{ inventory_hostname }}.crt"
  tls_key_file       = "/opt/vault/tls/{{ inventory_hostname }}.key"

  telemetry {
    unauthenticated_metrics_access = true
  }
}

telemetry {
  prometheus_retention_time = "60s"
  disable_hostname = true
}