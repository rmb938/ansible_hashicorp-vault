# ansible_hashicorp-vault
Ansible to Install [Hashicorp Vault](https://www.vaultproject.io/) on Ubuntu

## Requirements

* Tailscale installed and configured for ssh
    ```bash
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/$(lsb_release -cs).noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/$(lsb_release -cs).tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    sudo apt update
    sudo apt install tailscale
    sudo tailscale up --ssh --advertise-tags "tag:servers,tag:hashivault"
    ```
