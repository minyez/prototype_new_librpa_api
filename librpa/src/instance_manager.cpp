#include "instance_manager.h"

#include <cstddef>

namespace librpa_int
{

// manager[0] is a reserved sentinel (always nullptr); real instances start at 1.
std::vector<Dataset *> manager{nullptr};

}
