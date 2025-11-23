#pragma once
#include "interface_mpi.h"

namespace librpa_int
{

class Dataset
{
public:
    MPI_Comm comm_;
    int value = 0;

    Dataset(MPI_Comm comm): comm_(comm) {}

    void free() {};
    ~Dataset() { free(); }
};

}
