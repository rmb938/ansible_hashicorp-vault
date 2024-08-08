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

## Init & Unseal

This ansible currently does not initialize or unseal the Vault server.

Eventually there are plans to write a custom tool that uses TPM 2.0 to implement a auto-unseal similar to HSM auto-unsealing.

For detailed information on how to initialize Vault and unseal see the official Vault documentation here https://developer.hashicorp.com/vault/docs/commands/operator/init and here https://developer.hashicorp.com/vault/docs/concepts/seal#seal-unseal

### Init

Run the following command, change key-shares and key-threshold as needed.

`vault operator init -key-shares=3 -key-threshold=2`

Save and distribute the unseal keys.

Once Vault is initialized it is best pratice to revoke the initial root token using the following command

`vault token revoke ${token}`

### Unseal

Run the following command and enter the required number of keys

`vault operator unseal`

### Generate Root Token

To generate a new root token run the following commands

```bash
vault operator generate-root -generate-otp
vault operator generate-root -init
vault operator generate-root
```

Once you are done with the root token you can revoke it with the following command

`vault token revoke ${token}`