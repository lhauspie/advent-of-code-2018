// display_enum.cpp: Logan HAUSPIE
// build an enum of open/luberyard/tree and then try to display to stdout

#include <fstream>
#include <sstream>
#include <string>
#include <iostream>

enum Acre {
    open = '.', 
    tree = '|',
    lumberyard = '#'
};

Acre from(char c) {
    return (Acre)c;
}

int main() {
    std::cout << (char)Acre::open << std::endl;
    std::cout << (char)Acre::tree << std::endl;
    std::cout << (char)Acre::lumberyard << std::endl;

    std::cout << from('.') << std::endl;
    std::cout << from('|') << std::endl;
    std::cout << from('#') << std::endl;
    std::cout << from('o') << std::endl; // ??? oO ???
}