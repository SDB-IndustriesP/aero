# aero - Minimalism, evolved.
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c aero.c util.c
OBJ = ${SRC:.c=.o}

all: aero

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

aero: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f aero ${OBJ} aero-${VERSION}.tar.gz

dist: clean
	mkdir -p aero-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		aero.1 drw.h util.h ${SRC} transient.c aero-${VERSION}
	tar -cf aero-${VERSION}.tar aero-${VERSION}
	gzip aero-${VERSION}.tar
	rm -rf aero-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f aero ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/aero
	cp -f dwmswallow ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwmswallow
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < aero.1 > ${DESTDIR}${MANPREFIX}/man1/aero.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/aero.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/aero\
		${DESTDIR}${MANPREFIX}/bin/dwmswallow\
		${DESTDIR}${MANPREFIX}/man1/aero.1

.PHONY: all clean dist install uninstall
