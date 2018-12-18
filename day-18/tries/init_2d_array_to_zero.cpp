// build_2d_array_from_file.cpp: Logan HAUSPIE
// read the input.txt file line by line and then build a 2 dimensional array of enums

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
    Acre landscape[50][50] = {};
    for (int y = 0; y < 50; y++) {
        for (int x = 0; x < 50; x++) {
            landscape[y][x] = Acre::open;
            std::cout << (char)landscape[y][x];
        }
        std::cout << std::endl;
    }
}