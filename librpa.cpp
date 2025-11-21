#include "librpa.h"
#include "instance_manager.h"

// C APIs
LibrpaHandler* create_handler()
{
    // create a new instance
    int instance_id = manager.size();
    LibrpaObject *obj = new LibrpaObject;
    manager.emplace_back(obj);

    // initialize the corresponding handler
    // LibrpaHandler* h = new LibrpaHandler {instance_id};
    LibrpaHandler* h = new LibrpaHandler {instance_id};
    return h;
}

static void free_handler_data(LibrpaHandler *h)
{
    if (!h) return;
    // destroy the instance
    if (h->__instance_id > 0)
    {
        const auto id = h->__instance_id;
        // Invalid handler whose id was manually changed,
        // either oversubscription
        if (id >= manager.size())
        {
            h->__instance_id = 0;
            return;
        }
        auto &p = manager[id];
        // or pointed to an already released instance
        if (!p)
        {
            h->__instance_id = 0;
            return;
        }
        // free the instance before replace it with nullptr
        delete p;
        manager[id] = nullptr;
    }
    // set the id to 0 to invalidate
    h->__instance_id = 0;
}

void destroy_handler(LibrpaHandler *h)
{
    if (!h) return;
    free_handler_data(h);
    delete h;
}

static LibrpaObject* get_object(const LibrpaHandler *h)
{
    LibrpaObject* p = nullptr;
    if (h != nullptr)
    {
        const auto id = h->__instance_id;
        if (id >= 0 && id < manager.size()) p = manager[id];
    }
    return p;
}

static bool is_null_object(const LibrpaObject* p)
{
    return p == nullptr;
}


int get_value(const LibrpaHandler *h)
{
    int v = -1;
    const auto p = get_object(h);
    if (!is_null_object(p)) v = p->value;
    return v;
}

// C++ APIs
namespace librpa
{

Handler::Handler(): h(nullptr)
{
    h = create_handler();
}

Handler::~Handler()
{
    destroy_handler(h);
}

int get_value(const Handler &h)
{
    return get_value(h.get_c_handler());
}


}
