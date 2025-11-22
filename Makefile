OS := $(shell uname -s)
ifeq ($(OS), Linux)
    include make.inc.linux
endif
ifeq ($(OS), Darwin)
    include make.inc.macos
endif

LIB_C = lib$(LIBNAME_C).$(LIBEXT)
LIB_F = lib$(LIBNAME_F).$(LIBEXT)

objects_c = librpa.o instance_manager.o
objects_f = librpa_f.o

CXX ?= mpicxx
FC ?= mpifort
CC ?= mpicc

default: $(LIB_C) $(LIB_F) $(TARGET_C) $(TARGET_F)

$(TARGET_C): $(LIB_C) main.o
	$(CXX) -o $@ main.o $(LD_RPATH_FLAG) -L$(PWD) -l$(LIBNAME_C) -fopenmp

$(TARGET_F): $(LIB_C) $(LIB_F) main_f.o
	$(FC) -o $@ main_f.o $(LD_RPATH_FLAG) -L$(PWD) -l$(LIBNAME_F) -l$(LIBNAME_C) -lstdc++ -fopenmp

$(LIB_C): $(objects_c)
	$(CXX) $(SHARED_FLAG) -o $@ $^ -Wl,$(ARLD_OPT),$(ARLD_LIB_PREFIX)$(LIB_C)

$(LIB_F): $(objects_f)
	$(FC) $(SHARED_FLAG) -o $@ $^ -L$(PWD) -l$(LIBNAME_C) -Wl,$(ARLD_OPT),$(ARLD_LIB_PREFIX)$(LIB_F)

%.o: %.cpp
	$(CXX) -fopenmp -fPIC -o $@ -c $<

%.o: %.c
	$(CC) -fopenmp -fPIC -o $@ -c $<

%.o: %.f90
	$(FC) -fopenmp -fPIC -o $@ -c $<

clean:
	rm -f *.o *.mod *.exe* *.so *.dylib librpa_para*.out
