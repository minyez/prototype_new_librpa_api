#pragma once

// MPI related
#ifdef __MPI
#include <mpi.h>
#else

// All wrapped in ifndef, considering that the user might define in there own case.
// In that case, it is assumed that the user-defined macros are consistent with those in LibRPA
// Usually it is the case, since everyone shares the purpose to emulate MPI standard while keeping
// their code compilable with serial compiler.
// I do not know better solution at present, so finger crossed when it is not the case.

#ifndef MPI_Comm
#define MPI_Comm int
#endif

#ifndef MPI_COMM_WORLD
#define MPI_COMM_WORLD (MPI_Comm)0
#endif

#ifndef MPI_THREAD_MULTIPLE
#define MPI_THREAD_MULTIPLE 1
#endif

#ifndef MPI_Init_thread
#define MPI_Init_thread(argc, argv, req, prov) *prov = req; 0
#endif

#ifndef MPI_Finalize
#define MPI_Finalize() 0
#endif

#endif
