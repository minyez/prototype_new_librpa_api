#pragma once

class LibrpaDataset
{
public:
    int value = 0;

    void free() {};
    ~LibrpaDataset() { free(); }
};

