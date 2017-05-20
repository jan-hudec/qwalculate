# Qwalculate, web/hybrid interface for Qalculate.
# Copyright (c) 2017 Jan Hudec
# See COPYING for details.

EMSCRIPTEN_ROOT=$(shell sed "s/EMSCRIPTEN_ROOT='\\(.*\\)'/\\1/p;d" $(HOME)/.emscripten)
EMCONFIGURE=$(EMSCRIPTEN_ROOT)/emconfigure
ROOT=$(shell pwd)

# CLN
modules/cln/configure: modules/cln/configure.ac modules/cln/Makefile.am
	autoreconf -i modules/cln

build/modules/cln/Makefile: modules/cln/configure
	mkdir -p build/modules/cln
	cd build/modules/cln && $(EMCONFIGURE) ../../../modules/cln/configure --prefix=$(ROOT)/build/prefix --host asmjs CPPFLAGS="-DHZ=100"

cln: build/modules/cln/Makefile
	$(MAKE) -C build/modules/cln all install

# Misc
clean:
	rm -rf build
	for d in modules/*; do ( cd $$d && git clean -fdx ); done

.PHONY: cln clean
