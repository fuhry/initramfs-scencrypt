pkgname=initramfs-scencrypt
pkgdesc="initramfs hook that adds PGP smartcard support for LUKS FDE"
pkgver=1.8
pkgrel=1
license=(MIT)
arch=(any)
depends=(gnupg)
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
	cp "${srcdir}/README.md" "${pkgdir}/usr/share/doc/${pkgname}/"
}

md5sums=('SKIP'
         'SKIP'
         'SKIP')
