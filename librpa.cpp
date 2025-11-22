// Public headers (prefixed by librpa)
#include "librpa.h"

// Internal headers
#include "dataset.h"
#include "instance_manager.h"

// Internal functions to access datasets
static LibrpaDataset* get_dataset(const LibrpaHandler *h)
{
    LibrpaDataset* p = nullptr;
    if (h != nullptr)
    {
        const auto id = h->instance_id_;
        if (id >= 0 && id < manager.size()) p = manager[id];
    }
    return p;
}

static bool is_null_dataset_ptr(const LibrpaDataset* p)
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
