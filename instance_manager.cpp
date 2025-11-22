#include "instance_manager.h"
#include <cstddef>

// manager[0] is a reserved sentinel (always nullptr); real instances start at 1.
std::vector<LibrpaDataset *> manager{nullptr};
