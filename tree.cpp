
#include "tree.hpp"

node::node(nodeType nt, std::string nodeContent)
{
    this->nt = nt;
    this->nodeContent = nodeContent;
}

const std::string decode_node_type(nodeType n) {
    std::string typeString = "UNK";
    if (n == ID) {
        typeString = "ID";
    }else if (n == INTEGER_T) {
        typeString = "INTEGER";
    } else if (n == BOOL_T){
        typeString = "BOOLEAN";
    } else if (n == REAL_T){
        typeString = "REAL";
    } else if (n == CHAR_T){
        typeString = "CHAR";
    } else if (n == FUNCTIONAL_T){
        typeString = "FUNCTIONAL";
    } else {
        std::cout << "Could not decode type " << n << std::endl;
        exit(1);
    }
    return typeString;
}

void node::print()
{
    std::cout << "(" << decode_node_type(nt) << ", " << nodeContent << ")" << std::endl;
}

node::~node()
{
}


tree::tree(nodeType nt, std::string nodeContent)
{
    self_root = new node(nt, nodeContent);
    left = NULL;
    right = NULL;
}

void tree::print()
{
    std::cout << "A tree:" << std::endl;
    self_root->print();
    if (right) {
        std::cout << "It's right" << std::endl;
        right->print();
    }
    if (left) {
        std::cout << "It's left" << std::endl;
        left->print();
    }
}

tree::~tree()
{
    delete(self_root);
}

nodeType check_most_proeminent_type(tree* root, std::unordered_map<std::string, symbolInfo> symbolTable) {
    nodeType type = BOOL_T;
    if (root == NULL || root->self_root == NULL) {
        return type;
    }
    type = root->self_root->nt;
    if (type == ID) {
        auto it = symbolTable.find(root->self_root->nodeContent);
        if (it == symbolTable.end()) {
            std::cout << "WARNING: Symbol " << root->self_root->nodeContent << " not declared." << std::endl;
            type = UNKNOWN;
        } else {
            symbolInfo s = symbolTable[root->self_root->nodeContent];
            type = s.type;
        }
    }
    nodeType lmax = check_most_proeminent_type(root->left, symbolTable);
    nodeType rmax = check_most_proeminent_type(root->right, symbolTable);
    if (lmax > type) {
        type = lmax;
    }
    if (rmax > type) {
        type = rmax;
    }
    return type;
}

bool stob (std::string b_s) {
    if (b_s == "false") {
        return false;
    } else {
        return true;
    }
}

std::string btostr (bool b) {
    if (!b) {
        return "false";
    } else {
        return "true";
    }
}

std::string make_eval (tree* root, std::unordered_map<std::string, symbolInfo> symbolTable, nodeType type) {
    /* 
        ADDOP "+"|or
        MINUSOP "-"
        MULOP "*"|"/"|div|mod|and
    */
    if (type == REAL_T) {
        nodeType type_current_node = root->self_root->nt;
        std::string content_current_node = root->self_root->nodeContent;
        if (root->left == NULL && root->right == NULL) {
            std::string result = "0";
            if (type_current_node == ID) {
                result = symbolTable[content_current_node].value;
            } else if (type_current_node <= type) {
                result = content_current_node;
            } else {
                exit(1);
            }
            return result;
        }
        float current_result = 0;
        std::string left_calc = make_eval(root->left, symbolTable, type);
        std::string right_calc = make_eval(root->right, symbolTable, type);
        float l_result = std::stof(left_calc);
        float r_result = std::stof(right_calc);
        if (type_current_node == EXPR) {
            if (content_current_node == "+" || content_current_node == "or") {
                std::string result = std::to_string(l_result + r_result);
                return result;
            } else if (content_current_node == "-") {
                std::string  result = std::to_string(l_result - r_result);
                return result;
            } else if (content_current_node == "*" || content_current_node == "and") {
                std::string result = std::to_string(l_result * r_result);
                return result;
            } else if (content_current_node == "/" || content_current_node == "div") {
                std::string  result = std::to_string(l_result / r_result);
                return result;
            } else if (content_current_node == "mod") {
                std::string  result = std::to_string(fmod(l_result, r_result));
                return result;
            } else {
                std::cout << "Unknown operation " << content_current_node << std::endl;
                exit(1);
            }
        } else {
            return std::to_string(current_result);
        }
    } else if (type == INTEGER_T) {
        nodeType type_current_node = root->self_root->nt;
        std::string content_current_node = root->self_root->nodeContent;
        if (root->left == NULL && root->right == NULL) {
            std::string result = "0";
            if (type_current_node == ID) {
                result = symbolTable[content_current_node].value;
            } else if (type_current_node <= type) {
                result = content_current_node;
            } else {
                exit(1);
            }
            return result;
        }
        int current_result = 0;
        if (type_current_node == ID) {
            current_result = std::stoi(symbolTable[content_current_node].value);
        } else if (type_current_node == type) {
            current_result = std::stoi(content_current_node);
        }
        std::string left_calc = make_eval(root->left, symbolTable, type);
        std::string right_calc = make_eval(root->right, symbolTable, type);
        int l_result = std::stoi(left_calc);
        int r_result = std::stoi(right_calc);
        if (type_current_node == EXPR) {
            if (content_current_node == "+" || content_current_node == "or") {
                std::string result = std::to_string(l_result + r_result);
                return result;
            } else if (content_current_node == "-") {
                std::string result = std::to_string(l_result - r_result);
                return result;
            } else if (content_current_node == "*" || content_current_node == "and") {
                std::string result = std::to_string(l_result * r_result);
                return result;
            } else if (content_current_node == "/" || content_current_node == "div") {
                std::string result = std::to_string(l_result / r_result);
                return result;
            } else if (content_current_node == "mod") {
                std::string result = std::to_string(l_result % r_result);
                return result;
            } else {
                std::cout << "Unknown operation " << content_current_node << std::endl;
                exit(1);
            }
        } else {
            return std::to_string(current_result);
        }
    } else if (type == BOOL_T) {
        nodeType type_current_node = root->self_root->nt;
        std::string content_current_node = root->self_root->nodeContent;
        if (root->left == NULL && root->right == NULL) {
            std::string result = "0";
            if (type_current_node == ID) {
                result = symbolTable[content_current_node].value;
            } else if (type_current_node <= type) {
                result = content_current_node;
            } else {
                exit(1);
            }
            return result;
        }
        bool current_result = 0;
        if (type_current_node == ID) {
            current_result = stob(symbolTable[content_current_node].value);
        } else if (type_current_node == type) {
            current_result = stob(content_current_node);
        }
        std::string left_calc = make_eval(root->left, symbolTable, type);
        std::string right_calc = make_eval(root->right, symbolTable, type);
        bool l_result = stob(left_calc);
        bool r_result = stob(right_calc);
        if (type_current_node == EXPR) {
            if (content_current_node == "+" || content_current_node == "or") {
                std::string result = btostr(l_result || r_result);
                return result;
            } else if (content_current_node == "-") {
                std::cout << "Operation " << content_current_node << " not defined for boolean type." << std::endl;
                exit(1);
            } else if (content_current_node == "*" || content_current_node == "and") {
                std::string result = btostr(l_result && r_result);
                return result;
            } else if (content_current_node == "/" || content_current_node == "div") {
                std::cout << "Operation " << content_current_node << " not defined for boolean type." << std::endl;
                exit(1);
            } else if (content_current_node == "mod") {
                std::cout << "Operation " << content_current_node << " not defined for boolean type." << std::endl;
                exit(1);
            } else {
                std::cout << "Unknown operation " << content_current_node << std::endl;
                exit(1);
            }
        } else {
            return btostr(current_result);
        }
    } else {
        std::cout << "ERROR: Cannot eval expression of type " << type << std::endl;
        exit(1);
    }
}

void eval_tree (std::string id, tree* root, std::unordered_map<std::string, symbolInfo>& symbolTable) {
    // Do one traversal to get the predominant type in tree, check if identifiers have been declared and stuff
    nodeType type = BOOL_T;
    tree* visitor = root;
    type = check_most_proeminent_type(root, symbolTable);
    std::string total_val = make_eval(root, symbolTable, type);
    // Try to return the quadruple representation from here
    symbolInfo& si = symbolTable[id];
    si.value = total_val;
}

void gen_tuple(char* id, tree* expr_node, int depth, std::deque<std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo>>& quad_stack) {
    // this is the base, current node is an operation between two operands/ids
    if (expr_node == NULL) {
        std::cout << "Could not generate tuple for current tree." << std::endl;
        exit(1);
    }
    if (expr_node->left == NULL && expr_node->right == NULL) {
        if (depth == 1) {
            symbolInfo node_info (ASSING, std::string(id));
            symbolInfo left_node(expr_node->self_root->nt, expr_node->self_root->nodeContent);
            symbolInfo empty_node;
            std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo> node_quad ("=", left_node, empty_node, node_info);
            quad_stack.push_back(node_quad);
            return;
        } else {
            std::cout << "FATAL: Aborting!" << std::endl;
            exit(1);
        }
    }
    if (expr_node->left->self_root->nt > EXPR && expr_node->right->self_root->nt > EXPR) {
        std::string node_id;
        if (depth > 1) {
             node_id = "_temp" + std::to_string(depth);
        } else {
            node_id = std::string(id);
        }
        symbolInfo left_node(expr_node->left->self_root->nt, expr_node->left->self_root->nodeContent);
        symbolInfo right_node(expr_node->right->self_root->nt, expr_node->right->self_root->nodeContent);
        nodeType predominant;
        if (right_node.type > left_node.type) {
            predominant = right_node.type;
        } else {
            predominant = left_node.type;
        }
        symbolInfo node_info(predominant, node_id);
        std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo> node_quad (expr_node->self_root->nodeContent, left_node, right_node, node_info);
        quad_stack.push_back(node_quad);
        return;
    }
    // Left and right are expressions
    if (expr_node->left->self_root->nt <= EXPR && expr_node->right->self_root->nt <= EXPR) {
        // If only left and right are expressions, then this node will add a quad to stack: (OP, LEFT_TEMP, RIGHT_TEMP, CURRENT_TEMP)
        symbolInfo left_node(UNKNOWN, "_temp" + std::to_string(2*depth));
        symbolInfo right_node(UNKNOWN, "_temp" + std::to_string(2*depth+1));
        symbolInfo result_node(UNKNOWN, (depth == 1) ? std::string(id) : "_temp" + std::to_string(depth));
        std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo> node_quad (expr_node->self_root->nodeContent, left_node, right_node, result_node);
        quad_stack.push_back(node_quad);
        gen_tuple(id, expr_node->left, 2*depth, quad_stack);
        gen_tuple(id, expr_node->right, 2*depth+1, quad_stack);
    // Only left is expression
    } else if (expr_node->left->self_root->nt <= EXPR) {
        // If only left is expression, then this node will add a quad to stack: (OP, LEFT_TEMP, RIGHT, CURRENT_TEMP)
        symbolInfo left_node(UNKNOWN, "_temp" + std::to_string(2*depth));
        symbolInfo right_node(expr_node->right->self_root->nt, expr_node->right->self_root->nodeContent);
        symbolInfo result_node(UNKNOWN, (depth == 1) ? std::string(id) : "_temp" + std::to_string(depth));
        std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo> node_quad (expr_node->self_root->nodeContent, left_node, right_node, result_node);
        quad_stack.push_back(node_quad);
        gen_tuple(id, expr_node->left, 2*depth, quad_stack);
    // Only right is expression
    } else {
        // If only right is expression, then this node will add a quad to stack: (OP, LEFT, RIGHT_TEMP, CURRENT_TEMP)
        symbolInfo left_node(expr_node->left->self_root->nt, expr_node->left->self_root->nodeContent);
        symbolInfo right_node(UNKNOWN, "_temp" + std::to_string(2*depth+1));
        symbolInfo result_node(UNKNOWN, (depth == 1) ? std::string(id) : "_temp" + std::to_string(depth));
        std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo> node_quad (expr_node->self_root->nodeContent, left_node, right_node, result_node);
        quad_stack.push_back(node_quad);
        gen_tuple(id, expr_node->right, 2*depth+1, quad_stack);
    }
}

std::deque<std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo>> gen_quad(char* id, tree* expr_root) {
    /* Quad: (op, arg1, arg2, result) 
        We will need to break long trees into quads, creating temporaries for the result
        One ideia is to get every subtree, since everything is already defined as a quad expects
        Example: id1 = (2+5)*27 is the following tree
                *
               / \
              +  27
             / \
            2   5
        We can create one temporary for each operation node:
        (+, 2, 5, temp1)
        (*, temp1, 27, id1)
    */
   std::deque<std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo>> quads;
   gen_tuple(id, expr_root, 1, quads);
   return quads;
}

void check_type(std::string symbol, std::unordered_map<std::string, symbolInfo> symbol_table, tree* symbol_expr_tree, std::deque<std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo>>& symbol_expr_quad) {
    nodeType expr_type = check_most_proeminent_type(symbol_expr_tree, symbol_table);
    if (symbol_table[symbol].type < expr_type) {
        std::cout << "ERROR: Invalid assignment to " << symbol << "!" << std::endl;
        std::cout << symbol << " is " << symbol_table[symbol] << " expression is " << decode_node_type(expr_type) << std::endl;
    }
    std::unordered_map<std::string, nodeType> result_temps;
    // for (auto it = symbol_expr_quad.rbegin(); it != symbol_expr_quad.rend(); ++it) {
    //     symbolInfo& result = std::get<3>(*it);
    //     if (symbol == result.value){
    //         result.type = symbol_table[symbol].type;
    //     }
    // }
    for (auto it = symbol_expr_quad.rbegin(); it != symbol_expr_quad.rend(); ++it) {
        symbolInfo& arg1 = std::get<1>(*it);
        symbolInfo& arg2 = std::get<2>(*it);
        symbolInfo& result = std::get<3>(*it);
        if (result.value.find("_temp")!= std::string::npos && result.type != UNKNOWN) {
            result_temps.insert({result.value, result.type});
        }
        if (arg1.value.find("_temp")!= std::string::npos) {
            arg1.type = result_temps[arg1.value];
        }
        if (arg2.value.find("_temp")!= std::string::npos) {
            arg2.type = result_temps[arg2.value];
        }
        if (result.value.find("_temp")!= std::string::npos && result.type == UNKNOWN) {
            result.type = (arg1.type > arg2.type) ? arg1.type : arg2.type;
            result_temps.insert({result.value, result.type});
        } else if (symbol == result.value) {
            result.type = symbol_table[symbol].type;
        }
    }
}