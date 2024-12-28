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

## Init & Unseal

This ansible currently does not initialize Vault server.

For detailed information on how to initialize Vault here https://developer.hashicorp.com/vault/docs/commands/operator/init

### Init

Run the following command, change key-shares and key-threshold as needed.

`vault operator init -recovery-shares=3 -recovery-threshold=2`

Save and distribute the unseal keys.

Once Vault is initialized it is best pratice to revoke the initial root token using the following commands

```bash
vault login
vault token revoke -self
```

### Generate Root Token

To generate a new root token run the following commands

```bash
vault operator generate-root -init
vault operator generate-root -nonce=${NONCE_VALUE}
vault operator generate-root -decode=${ENCODED_TOKEN} -otp=${NONCE_OTP}
```

Once you are done with the root token you can revoke it with the following commands

```bash
vault login
vault token revoke -self
```