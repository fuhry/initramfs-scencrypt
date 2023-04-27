pkgname=initramfs-scencrypt
pkgdesc="initramfs hook that adds PGP smartcard support for LUKS FDE"
pkgver=2.0
pkgrel=1
license=(MIT)
arch=(any)
depends=(gnupg)
install=${pkgname}.install
source=(scencrypt-hook
		scencrypt-install
		systemd-initramfs-gpg-init.service
		systemd-initramfs-gpg-init
		systemd-gpg-decrypt@.service
		systemd-gpg-decrypt
		systemd-cryptsetup-pgp-keyfile@.service
		cryptsetup-gpg-dropin-generator
		95-smartcard.rules
		README.md)

build() {
	return 0
}

package() {
	mkdir -p "${pkgdir}/usr/lib/initcpio/hooks"
	install -oroot -m0755 "${srcdir}/scencrypt-hook" "${pkgdir}/usr/lib/initcpio/hooks/scencrypt"

	mkdir -p "${pkgdir}/usr/lib/initcpio/install"
	install -oroot -m0755 "${srcdir}/scencrypt-install" "${pkgdir}/usr/lib/initcpio/install/scencrypt"

	mkdir -p "${pkgdir}/usr/lib/systemd"
	install -oroot -m0755 "${srcdir}/systemd-initramfs-gpg-init" "${pkgdir}/usr/lib/systemd/systemd-initramfs-gpg-init"
	install -oroot -m0755 "${srcdir}/systemd-gpg-decrypt" "${pkgdir}/usr/lib/systemd/systemd-gpg-decrypt"

	mkdir -p "${pkgdir}/usr/lib/systemd/system-generators"
	install -oroot -m0755 "${srcdir}/cryptsetup-gpg-dropin-generator" "${pkgdir}/usr/lib/systemd/system-generators/cryptsetup-gpg-dropin-generator"

	mkdir -p "${pkgdir}/usr/lib/systemd/system"
	install -oroot -m0644 "${srcdir}/systemd-initramfs-gpg-init.service" "${pkgdir}/usr/lib/systemd/system/systemd-initramfs-gpg-init.service"
	install -oroot -m0644 "${srcdir}/systemd-gpg-decrypt@.service" "${pkgdir}/usr/lib/systemd/system/systemd-gpg-decrypt@.service"
	install -oroot -m0644 "${srcdir}/systemd-cryptsetup-pgp-keyfile@.service" "${pkgdir}/usr/lib/systemd/system/systemd-cryptsetup-pgp-keyfile@.service"

	mkdir -p "${pkgdir}/usr/lib/initcpio/udev"
	install -oroot -m0644 "${srcdir}/95-smartcard.rules" "${pkgdir}/usr/lib/initcpio/udev/95-smartcard.rules"

	mkdir -p "${pkgdir}/usr/share/doc/${pkgname}"
	cp "${srcdir}/README.md" "${pkgdir}/usr/share/doc/${pkgname}/"
}

sha256sums=('SKIP'
         'SKIP'
         'SKIP'
         'SKIP'
         'SKIP'
         'SKIP'
         'SKIP'
         'SKIP'
         'SKIP'
         'SKIP')
