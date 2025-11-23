#pragma once
#include "librpa_config.h"

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
