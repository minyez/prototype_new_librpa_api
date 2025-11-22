// Public headers (prefixed by librpa)
#include "librpa_handler.h"

// Internal headers
#include "dataset.h"
#include "instance_manager.h"

// C APIs
LibrpaHandler* librpa_create_handler()
{
    // create a new instance and append it to the manager
    int instance_id = librpa_int::manager.size();
    librpa_int::Dataset *obj = new librpa_int::Dataset;
    librpa_int::manager.emplace_back(obj);

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
        if (id >= librpa_int::manager.size()) return;
        auto &p = librpa_int::manager[id];
        // or pointed to an already released instance
        if (!p) return;
        // free the instance and point it to null pointer
        delete p;
        librpa_int::manager[id] = nullptr;
    }
}

void librpa_destroy_handler(LibrpaHandler *h)
{
    if (!h) return;
    free_handler_data(h);
    delete h;
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

}

