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

void librpa_init_options(LibrpaOptions *opts);

#ifdef __cplusplus
}
#endif

// C++ APIs
#ifdef __cplusplus

namespace librpa
{

// Straighforward inheritance
// IMPORTANT: DO NOT add extra member variables, which will break the data layout
class Options : ::LibrpaOptions
{
public:
    Options() { ::librpa_init_options(this); }
};

}

#endif
