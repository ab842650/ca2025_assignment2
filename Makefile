include ../../../mk/toolchain.mk

ARCH := -march=rv32i_zicsr -mabi=ilp32
LINKER_SCRIPT = linker.ld

EMU ?= ../../../build/rv32emu

OPT ?= -O0

AFLAGS = -g $(ARCH)
CFLAGS = -g $(ARCH) $(OPT)
LDFLAGS = -T $(LINKER_SCRIPT)
EXEC = test.elf

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJDUMP = $(CROSS_COMPILE)objdump

OBJS = start.o main_C.o perfcounter.o rsqrt_fast.o

.PHONY: all run dump clean

all: $(EXEC)

$(EXEC): $(OBJS) $(LINKER_SCRIPT)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

%.o: %.S
	$(AS) $(AFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@ -c

run: $(EXEC)
	@test -f $(EMU) || (echo "Error: $(EMU) not found" && exit 1)
	@grep -q "ENABLE_ELF_LOADER=1" ../../../build/.config || (echo "Error: ENABLE_ELF_LOADER=1 not set" && exit 1)
	@grep -q "ENABLE_SYSTEM=1" ../../../build/.config || (echo "Error: ENABLE_SYSTEM=1 not set" && exit 1)
	$(EMU) $<

dump: $(EXEC)
	$(OBJDUMP) -d -S $(EXEC) > dump.S
	@echo "Disassembly -> dump.S (OPT=$(OPT))"

clean:
	rm -f $(EXEC) $(OBJS)