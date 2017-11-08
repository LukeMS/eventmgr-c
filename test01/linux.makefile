_MAKEFILE_ABS = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
_TARGET := $(basename $(notdir $(realpath $(lastword $(_MAKEFILE_ABS)))))

BDIR = .
ODIR = obj
SDIR = .
IDIR = -I/usr/include -I/usr/include/absdt
LDIR = -L/usr/lib
LIBS = -leventmgr -labsdt -lzhash
CFLAGS = -static -Wall -W -ggdb -std=c99 $(IDIR) $(LDIR)

_OBJS := $(patsubst %.c,%.o,$(wildcard *.c))
OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))

clean_filenames := $(BDIR)/$(_TARGET).exe $(ODIR)/*.o $(ODIR)/*.d
clean_files := $(strip $(foreach f,$(clean_filenames),$(wildcard $(f))))

_dummy := $(shell mkdir -p "$(BDIR)" "$(ODIR)")

all: $(OBJS)
	gcc $(OBJS) $(LDIR) $(LIBS) $(IDIR) -o $(BDIR)/$(_TARGET)

run: all
	$(BDIR)/$(_TARGET)

valgrind: all
	valgrind --error-exitcode=666 --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --track-fds=yes $(BDIR)/$(_TARGET)

# pull in dependency info for *existing* .o files
-include $(OBJS:.o=.d)

# compile and generate dependency info
$(ODIR)/%.o: $(SDIR)/%.c
	gcc -c $(CFLAGS) $*.c -o $(ODIR)/$*.o
	gcc -MM $(CFLAGS) $*.c > $(ODIR)/$*.d

# remove compilation products
clean:
ifneq ($(clean_files),)
	rm -f $(clean_files)
endif