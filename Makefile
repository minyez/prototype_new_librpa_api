OS := $(shell uname -s)
ifeq ($(OS), Linux)
    include make.inc.linux
endif
ifeq ($(OS), Darwin)
    include make.inc.macos
endif

LIB_C = lib$(LIBNAME_C).$(LIBEXT)
LIB_F = lib$(LIBNAME_F).$(LIBEXT)

CXX ?= mpicxx
FC ?= mpifort
CC ?= mpicc

MPI_OK := $(shell \
  tmp_src=$$(mktemp mpi_test.XXXXXX.f90); \
  tmp_exe=$$(mktemp mpi_test.XXXXXX.exe); \
  printf 'program test_mpi\n  use mpi\n  integer :: ierr\n  call MPI_Init(ierr)\n  call MPI_Finalize(ierr)\nend program test_mpi\n' > $$tmp_src; \
  $(FC) $(MPI_FLAGS) $$tmp_src -o $$tmp_exe >/dev/null 2>&1 && echo yes || echo no; \
  rm -f $$tmp_src $$tmp_exe )

ifeq ($(MPI_OK),yes)
  MOD_MPI_OBJ := mod_mpi_parallel.o
else
  MOD_MPI_OBJ := mod_mpi_serial.o
endif

COMMFLAGS = -g -fopenmp -fPIC
CFLAGS = $(COMMFLAGS)
CXXFLAGS = $(COMMFLAGS)
FCFLAGS = $(COMMFLAGS)

# For debug
# FCFLAGS += -Wall -O0 -fbacktrace -fcheck=bounds -Wno-unused-variable -Wno-ampersand -Wno-tabs -Wno-unused-dummy-argument -Wuninitialized -fcheck=pointer -fallow-argument-mismatch -ffree-line-length-none

objects_c = librpa_options.o librpa_handler.o librpa.o instance_manager.o
objects_f = librpa_f03.o

default: $(LIB_C) $(LIB_F) $(TARGET_C) $(TARGET_CXX) $(TARGET_F)

$(TARGET_CXX): $(LIB_C) main.o
	$(CXX) -o $@ $(wordlist 2,$(words $^),$^) $(LD_RPATH_FLAG) -L$(PWD) -l$(LIBNAME_C) $(CFLAGS)

$(TARGET_C): $(LIB_C) main_c.o
	$(CC) -o $@ $(wordlist 2,$(words $^),$^) $(LD_RPATH_FLAG) -L$(PWD) -l$(LIBNAME_C)

$(TARGET_F): $(LIB_C) $(LIB_F) main_f.o $(MOD_MPI_OBJ)
	$(FC) -o $@ $(wordlist 3,$(words $^),$^) $(LD_RPATH_FLAG) -L$(PWD) -l$(LIBNAME_F) -l$(LIBNAME_C) -lstdc++

$(LIB_C): $(objects_c)
	$(CXX) $(SHARED_FLAG) -o $@ $^ -Wl,$(ARLD_OPT),$(ARLD_LIB_PREFIX)$(LIB_C)

$(LIB_F): $(objects_f)
	$(FC) $(SHARED_FLAG) -o $@ $^ -L$(PWD) -l$(LIBNAME_C) -Wl,$(ARLD_OPT),$(ARLD_LIB_PREFIX)$(LIB_F)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

%.o: %.f90 $(MOD_MPI_OBJ)
	$(FC) $(FCFLAGS) -o $@ -c $<

mod_mpi_%.o: mod_mpi_%.f90
	$(FC) $(FCFLAGS) -o $@ -c $<

clean:
	rm -rf *.o *.mod *.exe* *.so *.dylib librpa_para*.out
