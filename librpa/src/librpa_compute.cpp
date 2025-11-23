// Public headers (prefixed by librpa)
#include "../include/librpa_compute.h"

// Internal headers
#include "dataset.h"
#include "instance_manager.h"

// Internal functions to access datasets
static librpa_int::Dataset* get_dataset(const LibrpaHandler *h)
{
    librpa_int::Dataset* p = nullptr;
    if (h != nullptr)
    {
        const auto id = h->instance_id_;
        if (id >= 0 && id < librpa_int::manager.size()) p = librpa_int::manager[id];
    }
    return p;
}

static bool is_null_dataset_ptr(const librpa_int::Dataset* p)
{
    return p == nullptr;
}


int get_value(const LibrpaHandler *h)
{
    int v = -1;
    const auto p = get_dataset(h);
    if (!is_null_dataset_ptr(p)) v = p->value;
    return v;
}

// C++ APIs
// The functions here should be just wrappers of C APIs.
namespace librpa
{

int get_value(const Handler &h)
{
    return get_value(h.get_c_handler());
}


}
