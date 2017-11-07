#eventmgr

#makefile based on: scottmcpeak.com/autodepend/autodepend.html
#if depencies are renamed a make clean will be required

_MAKEFILE_ABS = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
_TARGET := $(basename $(notdir $(realpath $(lastword $(_MAKEFILE_ABS)))))
_CWD = $(_MAKEFILE_ABS)
.DEFAULT_GOAL = lib
$(info target->$(_TARGET) makefile_abs->$(_MAKEFILE_ABS) cwd->$(_MAKEFILE_ABS))

ODIR = obj
IDIR = inc
INC = -I$(IDIR) -I/d/Documents/c/absdatatypes/inc -I/d/Documents/c/zhash/inc
SDIR = .
LIB = -L/d/Documents/c/absdatatypes/lib -L/d/Documents/c/zhash/lib 
LIBS_SHORT = -lzhash -labsdatatypes
CFLAGS = -Wall -W -ggdb -std=c99 $(INC) $(LIB) $(LIBS_SHORT)

$(info target=lib$(_TARGET).a)

# https://www.gnu.org/software/make/manual/html_node/Wildcard-Function.html
_OBJS := $(patsubst %.c,%.o,$(wildcard *.c))
OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))

ifeq ($(DEST),)
DEST := lib
endif

clean_filenames := $(BDIR)/$(_TARGET).exe $(ODIR)/*.o $(ODIR)/*.d $(DEST)/lib$(_TARGET).a
clean_files := $(strip $(foreach f,$(clean_filenames),$(wildcard $(f))))

_dummy := $(shell mkdir -p "$(ODIR)" "$(DEST)")

# link
lib: $(OBJS) $(DEST)/lib$(_TARGET).a

$(DEST)/lib$(_TARGET).a:
	ar -cvqs $(DEST)/lib$(_TARGET).a $(OBJS)

# compile and generate dependency info
$(ODIR)/%.o: $(SDIR)/%.c
	gcc -c $(CFLAGS) $*.c -o $(ODIR)/$*.o
	gcc -MM $(CFLAGS) $*.c > $(ODIR)/$*.d

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