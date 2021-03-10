#include "symbolInfo.hpp"

symbolInfo::symbolInfo() {
    this->type = EMPTY;
    this->value = "0";
}

symbolInfo::symbolInfo(nodeType type, std::string value)
{
    this->type = type;
    this->value = value;
}

symbolInfo::symbolInfo(char* type, std::string value)
{
    std::string t = std::string(type);
    if (t == "INTEGER") {
        this->type = INTEGER_T;
    } else if (t == "BOOLEAN"){
        this->type = BOOL_T;
    } else if (t == "REAL"){
        this->type = REAL_T;
    } else if (t == "CHAR"){
        this->type = CHAR_T;
    } else {
        this->type = FUNCTIONAL_T;
    }
    this->value = value;
}

std::ostream& operator<<(std::ostream& os, const symbolInfo& si)
{
    nodeType t = si.type;
    std::string typeString;
    if (t == ID) {
        typeString = "ID";
    }else if (t == INTEGER_T) {
        typeString = "INTEGER";
    } else if (t == BOOL_T){
        typeString = "BOOLEAN";
    } else if (t == REAL_T){
        typeString = "REAL";
    } else if (t == CHAR_T){
        typeString = "CHAR";
    } else if (t == FUNCTIONAL_T){
        typeString = "FUNCTIONAL";
    } else {
        typeString = "UNK";
    }
    os << "(" << typeString << ", " << si.value << ")";
    return os;
}

symbolInfo symbolInfo::operator= (const symbolInfo& si)
{
    symbolInfo si_result (si.type, si.value);
    return si_result;
}

symbolInfo::~symbolInfo()
{
    
}