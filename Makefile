# Qwalculate, web/hybrid interface for Qalculate.
# Copyright (c) 2017 Jan Hudec
# See COPYING for details.

EMSCRIPTEN_ROOT=$(shell sed "s/EMSCRIPTEN_ROOT='\\(.*\\)'/\\1/p;d" $(HOME)/.emscripten)
EMCONFIGURE=$(EMSCRIPTEN_ROOT)/emconfigure
EMMAKE=$(EMSCRIPTEN_ROOT)/emmake
ROOT=$(shell pwd)

# CLN
modules/cln/configure: modules/cln/configure.ac modules/cln/Makefile.am
	autoreconf -i modules/cln

build/modules/cln/Makefile: modules/cln/configure
	mkdir -p build/modules/cln
	cd build/modules/cln && $(EMCONFIGURE) ../../../modules/cln/configure --prefix=$(ROOT)/build/prefix --host asmjs CPPFLAGS="-DHZ=100"

cln: build/modules/cln/Makefile
	$(EMMAKE) $(MAKE) -C build/modules/cln all install

# LibXML2
modules/libxml2/configure: modules/libxml2/configure.ac modules/libxml2/Makefile.am
	autoreconf -i modules/libxml2

build/modules/libxml2/Makefile: modules/libxml2/configure
	mkdir -p build/modules/libxml2
	cd build/modules/libxml2 && $(EMCONFIGURE) ../../../modules/libxml2/configure --prefix=$(ROOT)/build/prefix --host asmjs --with-http=no --with-ftp=no --with-python=no --with-threads=no --disable-shared

libxml2: build/modules/libxml2/Makefile
	$(EMMAKE) $(MAKE) -C build/modules/libxml2 EXEEXT=.js all install

# Misc
clean:
	rm -rf build
	for d in modules/*; do ( cd $$d && git clean -fdx ); done

.PHONY: cln libxml2 clean
