OS := $(shell uname -s)
ifeq ($(OS), Linux)
    include ../make.inc.linux
endif
ifeq ($(OS), Darwin)
    include ../make.inc.macos
endif
include ../make.inc.common

objects_lib_c = src/librpa_options.o src/librpa_handler.o src/librpa_compute.o src/instance_manager.o
objects_lib_f = binding/fortran/librpa_f03.o

.PHONY: default clean

default: $(LIB_C) $(LIB_F) include/librpa_f03.mod

$(LIB_C): $(objects_lib_c)
	$(CXX) $(SHARED_FLAG) -o $@ $^ -Wl,$(ARLD_OPT),$(ARLD_LIB_PREFIX)$(LIB_C)

$(LIB_F): $(objects_lib_f)
	$(FC) $(SHARED_FLAG) -o $@ $^ -L$(PWD) -l$(LIBNAME_C) -Wl,$(ARLD_OPT),$(ARLD_LIB_PREFIX)$(LIB_F)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

%.o: %.f90
	$(FC) $(FCFLAGS) -o $@ -c $<

include/librpa_f03.mod: binding/fortran/librpa_f03.o
	mv librpa_f03.mod $@
	@touch $@

clean:
	rm -rf *.o *.mod */*.o */*/*.o */*.mod *.so *.dylib
