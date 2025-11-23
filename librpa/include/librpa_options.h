#pragma once

// C APIs
#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
    int nfreq;
    int debug;
} LibrpaOptions;

// Initialize options to default values
void librpa_init_options(LibrpaOptions *opts);

#ifdef __cplusplus
}
#endif

// C++ APIs
#ifdef __cplusplus

namespace librpa
{

// Straighforward inheritance
// IMPORTANT: DO NOT add extra member variables here, which will break the inheritated data layout
// New control options should be put under the LibrpaOptions C structure
class Options : ::LibrpaOptions
{
public:
    Options() { ::librpa_init_options(this); }
};

}

#endif
