#include <cstddef>
// #include <mpi.h>
#include "librpa.h"
#include <iostream>
#include <iomanip>

#include <omp.h>  // Make sure to include OpenMP header

// static void initialize(int argc, char **argv)
// {
//     // MPI Initialization
//     int provided;
//     MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &provided);
//     if (MPI_THREAD_MULTIPLE != provided)
//     {
//         printf("Warning: MPI_Init_thread provide %d != required %d", provided, MPI_THREAD_MULTIPLE);
//     }
// }
// 
// static void finalize(bool success)
// {
//     MPI_Finalize();
// }

int main(int argc, char *argv[])
{
    using namespace std;

    // initialize(argc, argv);

    auto h = create_handler();
    cout << h->__instance_id << endl;

    auto h2 = create_handler();
    cout << h2->__instance_id << endl;
    destroy_handler(h2);

    cout << get_value(h) << endl;
    cout << get_value(h2) << endl;

    librpa::Handler h3;
    cout << h3.get_c_handler()->__instance_id << endl;
    cout << get_value(h3) << endl;

    destroy_handler(h);

    // finalize(true);
    return EXIT_SUCCESS;
}
