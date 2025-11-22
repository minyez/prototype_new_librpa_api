#pragma once

// C APIs
#ifdef __cplusplus
extern "C" {
#endif

struct LibrpaOptions
{
    int nfreq;
    int debug;
};

// Do not create by hand
struct LibrpaHandler
{
    // The only member: an integer that maps to the index of working instance in the manager.
    // The program may not work properly with manually created handler
    const int __instance_id;
};

void initialize_librpa_io();

LibrpaHandler* create_handler();

// void free_handler_data(LibrpaHandler *handler);

void destroy_handler(LibrpaHandler *h);

int get_value(const LibrpaHandler *handler);

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
    Handler();
    LibrpaHandler *get_c_handler() const { return h; }
    ~Handler();
};

int get_value(const Handler &h);

}

#endif
