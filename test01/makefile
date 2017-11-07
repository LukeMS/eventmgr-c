#makefile based on: scottmcpeak.com/autodepend/autodepend.html
#if depencies are renamed a make clean will be required

_MAKEFILE_ABS = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
_TARGET := $(basename $(notdir $(realpath $(lastword $(CURDIR)))))
$(info makefile=$(_MAKEFILE_ABS))
.DEFAULT_GOAL = run
_MAKEFILE_DIR := $(dir $(_MAKEFILE_ABS))


$(info make path=$(_MAKEFILE_DIR))
$(info target=$(_TARGET))
BDIR = bin
ODIR = obj
IDIR = ../inc
INC = -I$(IDIR) -I/d/Documents/c/absdatatypes/inc -I/d/Documents/c/zhash/inc
LIB = -L../lib  -L/d/Documents/c/absdatatypes/lib -L/d/Documents/c/zhash/lib 
#-lzhash -labsdatatypes are dependencies of -leventmgr, so the latter comes before them
LIBS_SHORT = -leventmgr -lzhash -labsdatatypes
SDIR = .
# -Wextra -Wpedantic 
CFLAGS = -static -Wall -W -ggdb -std=c99 $(INC) $(LIB)


# https://www.gnu.org/software/make/manual/html_node/Wildcard-Function.html
_OBJS := $(patsubst %.c,%.o,$(wildcard *.c))
OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))

_dummy := $(shell mkdir -p "$(BDIR)" "$(ODIR)")

clean_filenames := $(BDIR)/$(_TARGET).exe $(ODIR)/*.o $(ODIR)/*.d
clean_files := $(strip $(foreach f,$(clean_filenames),$(wildcard $(f))))


all: $(OBJS)
	gcc $(OBJS) $(LIB) $(LIBS_SHORT) -o $(BDIR)/$(_TARGET)

rundrm: all
	C:/dr_m/bin/drmemory -batch -- ./$(BDIR)/$(_TARGET).exe

run: all
	./$(BDIR)/$(_TARGET).exe

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