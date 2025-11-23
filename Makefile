OS := $(shell uname -s)
ifeq ($(OS), Linux)
    include make.inc.linux
endif
ifeq ($(OS), Darwin)
    include make.inc.macos
endif
include make.inc.common

ifeq ($(MPI_OK),yes)
  MOD_MPI_OBJ := mod_mpi_parallel.o
else
  MOD_MPI_OBJ := mod_mpi_serial.o
endif

LIBPATH_FLAGS = -L. -L./librpa
INC_FLAGS = -I./librpa/include

.PHONY: default libs

default: libs $(TARGET_C) $(TARGET_CXX) $(TARGET_F)

libs:
	cd librpa && $(MAKE)

librpa/$(LIB_C): libs

librpa/$(LIB_F): libs

$(TARGET_CXX): libs main.o
	$(CXX) -o $@ $(wordlist 2,$(words $^),$^) $(LD_RPATH_FLAG) $(LIBPATH_FLAGS) -l$(LIBNAME_C) $(CFLAGS)

$(TARGET_C): libs main_c.o
	$(CC) -o $@ $(wordlist 2,$(words $^),$^) $(LD_RPATH_FLAG) $(LIBPATH_FLAGS) -l$(LIBNAME_C)

$(TARGET_F): libs main_f.o $(MOD_MPI_OBJ)
	$(FC) -o $@ $(wordlist 2,$(words $^),$^) $(LD_RPATH_FLAG) $(LIBPATH_FLAGS) -l$(LIBNAME_F) -l$(LIBNAME_C) -lstdc++

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INC_FLAGS) -o $@ -c $<

%.o: %.c
	$(CC) $(CFLAGS) $(INC_FLAGS) -o $@ -c $<

%.o: %.f90 $(MOD_MPI_OBJ)
	$(FC) $(FCFLAGS) $(INC_FLAGS) -o $@ -c $<

mod_mpi_%.o: mod_mpi_%.f90
	$(FC) $(FCFLAGS) -o $@ -c $<

clean:
	rm -rf *.o *.mod *.exe* *.so *.dylib
