OS := $(shell uname -s)
ifeq ($(OS), Linux)
    include make.inc.linux
endif
ifeq ($(OS), Darwin)
    include make.inc.macos
endif

objects_c = main.o librpa.o instance_manager.o

CXX ?= mpicxx
FC ?= mpifort
CC ?= mpicc

default: $(TARGET_C)

$(TARGET_C): $(objects_c)
	$(CXX) -o $@ $^ -fopenmp

%.o: %.cpp
	$(CXX) -fopenmp -o $@ -c $<

%.o: %.c
	$(CC) -fopenmp -o $@ -c $<

clean:
	rm -f *.o $(TARGET_C) librpa_para*.out
