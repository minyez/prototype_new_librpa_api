#pragma once

namespace librpa_int
{

class Dataset
{
public:
    int value = 0;

    void free() {};
    ~Dataset() { free(); }
};

}
