#ifndef TREE_HPP
#define TREE_HPP

#include <string>
#include <unordered_map>
#include <tuple>
#include <deque>
#include "symbolInfo.hpp"
#include "enum_def.hpp"
#include <math.h>

class node
{
private:

public:
    nodeType nt;
    std::string nodeContent;
    node(nodeType nt, std::string nodeContent);
    void print();
    ~node();
};

class tree
{
private:

public:
    node* self_root;
    tree* left;
    tree* right;
    tree(nodeType nt, std::string nodeContent);
    void print();
    ~tree();
};

const std::string decode_node_type(nodeType n);
nodeType check_most_proeminent_type(tree* root, std::unordered_map<std::string, symbolInfo> symbolTable);
std::string make_eval (tree* root, std::unordered_map<std::string, symbolInfo> symbolTable, nodeType type);
void eval_tree (std::string id, tree* root, std::unordered_map<std::string, symbolInfo>& symbolTable);
void gen_tuple(char* id, tree* expr_node, int depth, std::deque<std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo>>& quad_stack);
std::deque<std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo>> gen_quad(char* id, tree* expr);
void check_type(std::string symbol, std::unordered_map<std::string, symbolInfo> symbol_table, tree* symbol_expr_tree, std::deque<std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo>>& symbol_expr_quad);
std::string btostr (bool b);
bool stob (std::string b_s);

#endif /* TREE_HPP */