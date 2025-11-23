#include <stdlib.h>
#include <stdio.h>

#include "config_mpi.h"
#include "librpa.h"

static void initialize(int argc, char **argv)
{
    // MPI Initialization
    int provided;
    MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &provided);
    // Initialization check
    if (MPI_THREAD_MULTIPLE != provided)
    {
        printf("Warning: MPI_Init_thread provide %d != required %d", provided, MPI_THREAD_MULTIPLE);
    }
}

static void finalize()
{
    MPI_Finalize();
}

int main(int argc, char *argv[])
{
    initialize(argc, argv);

    LibrpaHandler *h;
    h = librpa_create_handler();
    int a = get_value(h);
    printf("%d\n", a);
    librpa_destroy_handler(h);

    finalize();
    return EXIT_SUCCESS;
}
