#include <cstddef>
#include <iostream>

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
    using namespace std;

    // initialize(argc, argv);

    auto h = librpa_create_handler(MPI_COMM_WORLD);
    cout << h->instance_id_ << endl;

    // Create twice without destorying first will lead to memory leak
    // h = librpa_create_handler();

    auto h2 = librpa_create_handler(MPI_COMM_WORLD);
    cout << h2->instance_id_ << endl;
    librpa_destroy_handler(h2);

    cout << get_value(h) << endl;
    cout << get_value(h2) << endl;

    librpa::Handler h3(MPI_COMM_WORLD);
    cout << h3.get_c_handler()->instance_id_ << endl;
    cout << get_value(h3) << endl;

    librpa_destroy_handler(h);

    LibrpaOptions opts;
    cout << "opts.nfreq " << opts.nfreq << endl;
    cout << "opts.debug " << opts.debug << endl;
    librpa_init_options(&opts);
    cout << "opts.nfreq " << opts.nfreq << endl;
    cout << "opts.debug " << opts.debug << endl;

    librpa::Options opts_cpp; // automatic initialization by constructor
    cout << "opts_cpp.nfreq " << opts.nfreq << endl;
    cout << "opts_cpp.debug " << opts.debug << endl;

    finalize();
    return EXIT_SUCCESS;
}
