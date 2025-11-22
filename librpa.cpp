#include "librpa.h"
#include "instance_manager.h"
#include "librpa_dataset.h"

// C APIs

void librpa_init_options(LibrpaOptions *opts)
{
    opts->nfreq = 6;
    opts->debug = 0;
}

LibrpaHandler* librpa_create_handler()
{
    // create a new instance and append it to the manager
    int instance_id = manager.size();
    LibrpaDataset *obj = new LibrpaDataset;
    manager.emplace_back(obj);

    // initialize a binding handler
    LibrpaHandler* h = new LibrpaHandler {instance_id};
    return h;
}

// free the data instance that the handler binds
static void free_handler_data(LibrpaHandler *h)
{
    if (!h) return;
    // destroy the instance
    if (h->instance_id_ > 0)
    {
        const auto id = h->instance_id_;
        // Invalid handler that was manually created with hand-picked id,
        // either oversubscription
        if (id >= manager.size()) return;
        auto &p = manager[id];
        // or pointed to an already released instance
        if (!p) return;
        // free the instance and point it to null pointer
        delete p;
        manager[id] = nullptr;
    }
}

void librpa_destroy_handler(LibrpaHandler *h)
{
    if (!h) return;
    free_handler_data(h);
    delete h;
}

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

static bool is_null_object(const LibrpaDataset* p)
{
    return p == nullptr;
}


int get_value(const LibrpaHandler *h)
{
    int v = -1;
    const auto p = get_dataset(h);
    if (!is_null_object(p)) v = p->value;
    return v;
}

// C++ APIs
namespace librpa
{

Handler::Handler(): h(nullptr)
{
    h = ::librpa_create_handler();
}

Handler::~Handler()
{
    ::librpa_destroy_handler(h);
}

int get_value(const Handler &h)
{
    return get_value(h.get_c_handler());
}


}
