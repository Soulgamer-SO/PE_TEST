CC = gcc -m64 -std=c17
DEBUG = DEBUG
_DEFAULT_SOURCE = _DEFAULT_SOURCE
PE_path = PainterEngine/
project_src_path := project/
project_src := $(wildcard $(project_src_path)*.c)
project_o := $(patsubst %.c,%.o,$(project_src))
project_h := $(patsubst %.c,%.h,$(project_src))
target_path_debug := $(project_src_path)debug/
target_path_release := $(project_src_path)release/
PE_INCLUDE_HEADER = -I $(PE_path) -I $(project_src_path) -I $(PE_path)runtime -I $(PE_path)platform/linux  -I $(PE_path)platform/modules
LD_LIBRARY_FLAGS = -L. -lGL -lglut -lpthread
core_src_path := $(PE_path)core/
core_src := $(wildcard $(core_src_path)*.c)
core_o := $(patsubst %.c,%.o,$(core_src))
core_h := $(patsubst %.c,%.h,$(core_src))
kernel_src_path := $(PE_path)kernel/
kernel_src := $(wildcard $(kernel_src_path)*.c)
kernel_o := $(patsubst %.c,%.o,$(kernel_src))
kernel_h := $(patsubst %.c,%.h,$(kernel_src))
#on Linux
ifeq ($(shell uname),Linux)
    ifeq ($(shell uname -m),x86_64)
        platform_src_path := $(PE_path)platform/linux/
        target_bin := PE_TEST
   endif
endif
#on Windows
ifeq ($(OS),Windows_NT)
    platform_src_path := $(PE_path)platform/windows/
    target_bin := PE_TEST.exe
endif
platform_src := $(wildcard $(platform_src_path)*.c)
platform_o := $(patsubst %.c,%.o,$(platform_src))
platform_h := $(patsubst %.c,%.h,$(platform_src))

runtime_src_path := $(PE_path)runtime/
runtime_src := $(wildcard $(runtime_src_path)*.c)
runtime_o := $(patsubst %.c,%.o,$(runtime_src))
runtime_h := $(patsubst %.c,%.h,$(runtime_src))

PE_TEST_src := $(runtime_src) $(kernel_src) $(core_src) $(platform_src)
PE_TEST_o := $(runtime_o) $(kernel_o) $(core_o) $(platform_o)

# make
all:$(PE_TEST_src)
	$(CC) $(project_src) $(PE_TEST_src) -D $(_DEFAULT_SOURCE) -O0 -o $(target_path_release)$(target_bin) $(LD_LIBRARY_FLAGS)
.PHONY:debug release install clean
debug:$(project_src) $(PE_TEST_src)
	$(CC) $(project_src) $(PE_TEST_src) -g -D $(_DEFAULT_SOURCE) -O0 -o $(target_path_debug)$(target_bin) $(LD_LIBRARY_FLAGS)
release:$(project_src) $(PE_TEST_src)
	$(CC) $(project_src) $(PE_TEST_src) -D $(_DEFAULT_SOURCE) -O0  -o $(target_path_release)$(target_bin) $(LD_LIBRARY_FLAGS)
install:

clean:
	-rm $(core_o)
	-rm $(kernel_o)
	-rm $(platform_o)
	-rm $(project_o)
	-rm $(runtime_o)
	-rm $(target_path_debug)$(target_bin)
	-rm $(target_path_release)$(target_bin)
