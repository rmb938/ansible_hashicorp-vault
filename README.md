# ansible_hashicorp-vault
Ansible to Install [Hashicorp Vault](https://www.vaultproject.io/) on Ubuntu

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