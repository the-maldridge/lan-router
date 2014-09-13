.PHONY: site clean

DESTDIR = ${CURDIR}/tmp
SUDO = sudo
INSTALL = install
OSrev=55

# OpenBSD UID and GID definitions
ROOT_U = 0
WHEEL_G = 0
NSD_G = 97

# -rw-r--r--
BIN1=	etc/dhcpd.conf \
	etc/pkg.conf \
	etc/rc.conf.local \
	etc/rc.securelevel \
	etc/sysctl.conf

# -rw-r-----
HOSTNAMES=	etc/hostname.ath0 \
		etc/hostname.bge0 \
		etc/hostname.bge1 \
		etc/hostname.bridge0 \
		etc/hostname.vether0

site:
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}
	# In the OpenBSD Makefile this part is done by mtree but that doesn't exist on linux
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/etc
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/nsd
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${NSD_G} -m 750 ${DESTDIR}/var/nsd/etc
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/nsd/zones
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/unbound
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/unbound/etc
	${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 550 install.site ${DESTDIR}
	cd root; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 ${BIN1} ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 640 ${HOSTNAMES} ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 600 etc/pf.conf ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${NSD_G} -m 640 var/nsd/etc/nsd.conf ${DESTDIR}/var/nsd/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 var/nsd/zones/lan-party ${DESTDIR}/var/nsd/zones; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 var/nsd/zones/9.0.10.in-addr.arpa ${DESTDIR}/var/nsd/zones; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 var/unbound/etc/unbound.conf ${DESTDIR}/var/unbound/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 var/unbound/etc/root.hint ${DESTDIR}/var/unbound/etc;
	${SUDO} tar czf site${OSrev}.tgz -C${DESTDIR} .

clean:
	${SUDO} rm -rf ${DESTDIR}
	${SUDO} rm -f site*.tgz
