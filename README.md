# ansible_hashicorp-vault
Ansible to Install [Hashicorp Vault](https://www.vaultproject.io/) on Ubuntu

## Requirements

* Tailscale installed and configured for ssh
    ```bash
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    sudo apt-get update
    sudo apt-get install tailscale
    sudo tailscale up --ssh --advertise-tags "tag:servers,tag:hashivault,tag:hvpolicy-default"
    ```

## Run

```bash
ansible-playbook -i hosts site.yaml -v --diff
```

## Init

This ansible will automatically initialize the Vault Cluster.

## Auto Unseal

This ansible sets up a form of auto unseal using a TPM2 and host key.

The host+tpm2 encrypted file is located at `/etc/vault.d/vault-init.json.enc` on the `init_server` with the unseal keys.

If you need to decrypt the file manually run `systemd-creds decrypt /etc/vault.d/vault-init.json.enc -`.

If you need to prevent the decryption to revoke the auto-unseal run `tpm2_clear`.

Every 5 minutes the `vault-unseal` service will run to make sure all Vault servers are unsealed.

## Root Token Generation

Root tokens should only be used and generated on the `init_server`.

You can generate a root token and login by running `vault-root-login`.
Running this command more then once will revoke the previous root token

Root tokens generated in this manner will automatically be revoked every 1 hour.