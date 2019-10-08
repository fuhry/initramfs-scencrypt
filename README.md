# GnuPG hook for Arch Linux initcpio

This initcpio hook allows you to use a PGP-compatible smart card during early boot to decrypt your full disk encrypted system.

# Why?

This is a great solution if you want the best possible encryption strength, but without having to type a huge passphrase in every time you boot. Using a hardware-backed RSA key on a PGP smart card, with the card performing decryption of the FDE key on-chip without releasing the private key to the OS, gives you extremely strong protection from attacks, even sophisticated/well-equipped adversaries.

As is the case with all LUKS systems, anyone who gets root on your box after it's booted can run `dmsetup table --showkeys` to dump the master key, the changing of which requires a complete wipe of your disk, in contrast to LUKS user key changing which requires only wiping and replacing the key slot. So don't let an adversary get root - watch your setuid programs, sudo rights, running services, etc. carefully.

PGP smart cards have varying options for PIN limits and reset or self-destruct functionality - choose one that fits your needs.

This hook has only been tested with the YubiKey NEO.

## Disclaimer

Use this hook at your own risk. It's highly recommended to have a backup key somewhere, in case you lose or destroy your primary key.

# Configuration process

1. Install Arch onto a LUKS encrypted system and get it booting using the stock `encrypt` hook and passphrase. (Beyond the scope of this document)
1. Configure your smartcard and get it working to the point that you can encrypt and decrypt things on your machine using the card. (Beyond the scope of this document)
1. Generate a new random key and encrypt it: `dd if=/dev/random bs=64 count=1 | gpg --encrypt -r your@email.tld > disk.bin.gpg`
1. Decrypt the key into memory so you can add it to your LUKS volume: `gpg --decrypt -o /dev/shm/disk.bin disk.bin.gpg`
1. `sudo cryptsetup luksAddKey /dev/your_luks_device /dev/shm/disk.bin`
1. `shred -u -n1 /dev/shm/disk.bin` to delete the decrypted `disk.bin` file from memory.
1. Edit `/etc/crypttab` to include your encrypted device. The line will look somewhat like:
   `arch_crypt        /dev/your_luks_device               /home/you/disk.bin.gpg         discard`
1. Edit `/etc/mkinitcpio.conf` and replace the `encrypt` hook with `scencrypt`. Do not leave both `encrypt` and `scencrypt` enabled.
1. Make sure `root` has a GPG keychain with your public key (e.g. `gpg --export -a 0x13C7C0BA66FB8DC7 > ~/pub.gpg`, `sudo su`, `gpg --import /home/<user>/pub.gpg`
1. Run `mkinitcpio -p linux`. If there are no errors, reboot with your smart card plugged in to find out if it works.
1. (Optional) `sudo cryptSetup luksRemoveKey /dev/your_luks_device` and type the passphrase you added when you were installing Arch. This will remove the old passphrase so that only your GPG-encrypted key file can unseal the disk.

# Technical details

The hook works by copying your encrypted key file to the initramfs, decrypting it in memory, passing it to LUKS to unseal the disk, and then using `shred` to overwrite it in memory.

Behind the scenes, `gpg` starts `scdaemon`, which talks to `pcscd` and `pinentry-tty` to get your PIN and pass it to the card along with the payload for decryption. The private key itself is held securely on the smartcard - it cannot be released even with the PIN on hand. But the decryption is quick because the payload is small. Once the disk is mounted, the smartcard can safely be removed from the system - the result of the decryption is merely a "user key" that LUKS uses to decrypt the volume's master key. There is an excellent [white paper](http://clemens.endorphin.org/nmihde/nmihde-A4-ds.pdf) written by one of the original LUKS authors detailing LUKS's extensive anti-forensic hardening.

The hook will prefer `cryptkey=` kernel cmdline argument if present. It uses the same options as the stock `encrypt` hook, refer to the `cryptsetup` package for details. This allows you to use `kexec` without having to re-insert your YubiKey. For this to work you can kexec-load a `initrd` which contains the plain key file. For security reasons that initrd shall only reside in RAM. Have a look at [kexec-example.sh](kexec-example.sh).

# How to contribute

1. Fork the repository
1. If you're fixing a bug, create an issue for it. New features/enhancements don't need an issue created.
1. Work in a branch ideally named after the issue you're working on, if applicable
1. When ready for review, open a pull request.
1. Don't update version numbers - the maintainers will do this when new versions are released.
1. If you're a first time contributor, add your name, PGP key ID and GitHub username to [CONTIRBUTORS.md](CONTRIBUTORS.md). **If you have not done this, your pull request will not be accepted.**
