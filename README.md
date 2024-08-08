# ansible_hashicorp-vault
Ansible to Install [Hashicorp Vault](https://www.vaultproject.io/) on Ubuntu

This ansible install sets up Vault to be "auto-unsealed" with a TPM 2.0 module using [go-tpm-tools](https://github.com/google/go-tpm-tools). This is similar to https://developer.hashicorp.com/vault/docs/configuration/seal/pkcs11 but without the need for an HSM or a Vault enterprise license.

## Requirements

* Tailscale installed and configured for ssh
    ```bash
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/$(lsb_release -cs).noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/$(lsb_release -cs).tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    sudo apt update
    sudo apt install tailscale
    sudo tailscale up --ssh --advertise-tags "tag:servers,tag:hashivault"
    ```
* TPM Setup on the Ubuntu Machine
    * i.e in TrueNAS Scale run the following after creating the VM
        ```bash
        cli -c "service vm query" # To list your VMs and find the Vault ID
        cli -c "service vm update id=${vm-id} machine_type=q35 arch_type=x86_64 trusted_platform_module=true"
        ```

## TPM Auto-Unseal

1. Vault will be initialized with `vault operator init -key-shares=1 -key-threshold=1 -format=json`
1. The output will be sent to `gotpm seal` to create an encrypted file encrypted by the TPM.
    * The data is sealed with [pcr 7](https://wiki.archlinux.org/title/Trusted_Platform_Module#Accessing_PCR_registers), which means enabling, disabling, or changing secure boot keys will cause the cyphertext to no longer be valid.
    * It is highly recommended to read the encrypted data and either back it up and/or distribute the key-shares as instructed by the Vault documentation. See [Manually Decrypt Unseal Keys](#manually-decrypt-unseal-keys).
1. A systemd timer called `vault-tpm-unseal` will be started an immediately ran to unseal the vault using the cyphertext data.
1. The initial root token created by the `vault operator init` will then be revoked following Vault's best practice.

## Manually Decrypt Unseal Keys

Steps for manually decrypting the Vault unseal keys

1. Run `sudo gotpm unseal --input /opt/vault/unseal-keys.enc --pcrs 7`