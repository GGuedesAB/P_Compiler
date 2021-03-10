#ifndef SYMBOLINFO_HPP
#define SYMBOLINFO_HPP

#include "y.tab.h"
#include "enum_def.hpp"
#include <string>
#include <iostream>
#include <unordered_map>


class symbolInfo
{
private:
public:
    nodeType type;
    std::string value;
    symbolInfo();
    symbolInfo(nodeType type, std::string value);
    symbolInfo(char* type, std::string value);
    symbolInfo operator= (const symbolInfo& si);
    friend std::ostream& operator<<(std::ostream& os, const symbolInfo& si);
    ~symbolInfo();
};

#endif /* SYMBOLINFO_HPP */