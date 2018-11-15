#-------------------------------------------------------------------------
#
# Makefile for src/samples/ksys
#
# $Header: $
#
#-------------------------------------------------------------------------

subdir = src/samples/ksys
top_builddir = ../../..
include $(top_builddir)/src/Makefile.global

FILES := ksys.pas main.ddp main.dfm main.pas \
         Test.cfg Test.dof Test.dpr Test.res \
         README

all:

install: all installdirs
	for file in $(FILES); do \
	  $(INSTALL_DATA) $(srcdir)/$$file $(DESTDIR)$(samplesdir)/ksys || exit; \
	done

installdirs:
	$(mkinstalldirs) $(DESTDIR)$(samplesdir)/ksys

uninstall:
	rm -rf $(DESTDIR)$(samplesdir)/ksys

clean:

distclean maintainer-clean: clean

