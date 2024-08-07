# {{ ansible_managed }}

ui            = true
cluster_addr  = "https://{{ inventory_hostname }}:8201"
api_addr      = "https://{{ inventory_hostname }}:8200"
disable_mlock = true

default_lease_ttl = "7d"

storage "raft" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address       = "{% raw %}{{ GetInterfaceIP \"tailscale0\" }}{% endraw %}:8200"
  tls_cert_file = "/opt/vault/tls/{{ inventory_hostname }}.crt"
  tls_key_file  = "/opt/vault/tls/{{ inventory_hostname }}.key"
}

telemetry {
  prometheus_retention_time = "60s"
  disable_hostname = true
  unauthenticated_metrics_access = true
}