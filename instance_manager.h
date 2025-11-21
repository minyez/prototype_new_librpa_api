#pragma once
#include <vector>

class LibrpaObject
{
public:
    int value = 0;

    void free() {};
    ~LibrpaObject() { free(); }
};

extern std::vector<LibrpaObject*> manager;
