#pragma once

#ifdef __MPI
#include <mpi.h>
#else
#define MPI_THREAD_MULTIPLE 1
#define MPI_Init_thread(argc, argv, req, prov) *prov = req
#define MPI_Finalize()
#endif
