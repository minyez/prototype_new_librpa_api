#pragma once
#include "librpa_config.h"

// C APIs
#ifdef __cplusplus
extern "C" {
#endif

// Do not create by hand
typedef struct
{
    // The only member: an integer that maps to the index of working instance in the manager.
    // The program may not work properly with manually created handler
    const int instance_id_;
} LibrpaHandler;

LibrpaHandler* librpa_create_handler(MPI_Comm comm);

// void free_handler_data(LibrpaHandler *handler);

void librpa_destroy_handler(LibrpaHandler *h);

#ifdef __cplusplus
}
#endif

// C++ APIs
#ifdef __cplusplus

namespace librpa
{

class Handler
{
private:
    LibrpaHandler *h;
public:
    Handler(MPI_Comm comm);
    LibrpaHandler *get_c_handler() const { return h; }
    ~Handler();
};

}

#endif
