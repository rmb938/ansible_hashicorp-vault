# {{ ansible_managed }}

ui            = true
cluster_addr  = "https://{{ ansible_fqdn }}:8201"
api_addr      = "https://{{ ansible_fqdn }}:8200"
disable_mlock = true

default_lease_ttl = "7d"

storage "raft" {
  path = "/opt/vault/data"
  node_id = "{{ ansible_fqdn }}"

  retry_join {
    leader_api_addr = "https://hashi-vault.haproxy.rmb938.me"
  }
}

listener "tcp" {
  address = "{% raw %}{{ GetInterfaceIP \"eth0\" }}{% endraw %}:8200"

  tls_cert_file      = "/opt/vault/tls/vault.crt"
  tls_key_file       = "/opt/vault/tls/vault.crt.key"
  tls_client_ca_file = "/opt/vault/tls/ca.crt"

  x_forwarded_for_authorized_addrs            = ["192.168.23.49", "192.168.23.50"]
  x_forwarded_for_client_cert_header          = "X-SSL-Client-Cert"
  x_forwarded_for_client_cert_header_decoders = "BASE64"

  telemetry {
    unauthenticated_metrics_access = true
  }
}

listener "tcp" {
  address = "{% raw %}{{ GetInterfaceIP \"tailscale0\" }}{% endraw %}:8200"

  tls_cert_file      = "/opt/vault/tls/vault.crt"
  tls_key_file       = "/opt/vault/tls/vault.crt.key"
  tls_client_ca_file = "/opt/vault/tls/ca.crt"
}

telemetry {
  prometheus_retention_time = "60s"
  disable_hostname = true
}