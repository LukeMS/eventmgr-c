eventmgr = libeventmgr.a

IDIR = -Iinc -I/usr/include -I/usr/include/absdt
LDIR = -L/usr/lib
ODIR = obj
SDIR = .
LIBS = -lzhash -labsdt
CFLAGS = -static -Wall -W -ggdb -std=c99 $(IDIR) $(LDIR) $(LIBS)

_OBJS := $(patsubst %.c,%.o,$(wildcard *.c))
OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))

_dummy := $(shell mkdir -p "$(ODIR)")

$(eventmgr): $(OBJS)
	$(AR) rcs $@ $^

.PHONY: install
install: $(eventmgr)
	mkdir -p /usr/lib
	mkdir -p /usr/include
	cp $(eventmgr) /usr/lib/$(eventmgr)
	cp inc/eventmgr.h /usr/include

.PHONY: uninstall
uninstall:
	rm -f /usr/lib/$(eventmgr)
	rm -f /usr/include/eventmgr.h

# pull in dependency info for *existing* .o files
-include $(OBJS:.o=.d)

# compile and generate dependency info
$(ODIR)/%.o: $(SDIR)/%.c
	gcc -c $(CFLAGS) $*.c -o $(ODIR)/$*.o
	gcc -MM $(CFLAGS) $*.c > $(ODIR)/$*.d