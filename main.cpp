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
    cout << h->instance_id_ << endl;

    // Create twice without destorying first will lead to memory leak
    // h = create_handler();

    auto h2 = create_handler();
    cout << h2->instance_id_ << endl;
    destroy_handler(h2);

    cout << get_value(h) << endl;
    cout << get_value(h2) << endl;

    librpa::Handler h3;
    cout << h3.get_c_handler()->instance_id_ << endl;
    cout << get_value(h3) << endl;

    destroy_handler(h);

    LibrpaOptions opts;
    cout << "opts.nfreq " << opts.nfreq << endl;
    cout << "opts.debug " << opts.debug << endl;

    // finalize(true);
    return EXIT_SUCCESS;
}
