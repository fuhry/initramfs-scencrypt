pkgname=initramfs-scencrypt
pkgdesc="initramfs hook that adds PGP smartcard support for LUKS FDE"
pkgver=1.0
pkgrel=2
arch=(any)
depends=(gnupg pcsclite libusb-compat)
install=${pkgname}.install
source=(scencrypt-hook
		scencrypt-install
		README.md)

build() {
	return 0
}

package() {
	mkdir -p "${pkgdir}/usr/lib/initcpio/hooks"
	mkdir -p "${pkgdir}/usr/lib/initcpio/install"

	cp "${srcdir}/scencrypt-hook" "${pkgdir}/usr/lib/initcpio/hooks/scencrypt"
	cp "${srcdir}/scencrypt-install" "${pkgdir}/usr/lib/initcpio/install/scencrypt"
	
	mkdir -p "${pkgdir}/usr/share/doc/${pkgname}"
	cp -a "${srcdir}/README.md" "${pkgdir}/usr/share/doc/${pkgname}/"
}

md5sums=('159bfe688d4e2784c9c9882bb33c6fac'
         'a497d9a7ae1918db780377c76004afa3'
         '6c68b216a5346c9e936a06cd4b839f7f')
