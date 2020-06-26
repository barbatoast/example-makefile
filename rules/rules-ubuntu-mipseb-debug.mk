# Setup compiler/loader flags here. Don't put module specific flags here, define them in the
# <module>/module.mk file.

BOARD:=ubuntu
ARCH:=mipseb
VER:=all
MODE:=debug

CFLAGS+= -D__UBUNTU__

INCLUDE_PATH=/usr/include
LD_LIBRARY_PATH=/usr/lib
CROSSPATH=/usr/bin/
GCC=$(CROSSPATH)mips-linux-gnu-gcc
CC=$(GCC)

# architecture-specific test exclusions
EXCLUDE_COMMANDS=

# define where the build goes
BUILD=build/$(MODE)/$(BOARD)-$(ARCH)-$(VER)
ALL_LDFLAGS=
ALL_YFLAGS=
ALL_CFLAGS?= -O2 -s -DDEBUG $(CFLAGS) $(EXCLUDE_COMMANDS)
