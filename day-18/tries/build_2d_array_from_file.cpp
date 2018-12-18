// build_2d_array_from_file.cpp: Logan HAUSPIE
// read the input.txt file line by line and then build a 2 dimensional array of enums

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
    std::ifstream infile("input.txt");
    std::string line;

    Acre landscape[50][50] = {};

    int y = 0;
    while (std::getline(infile, line)) {
        for (int x = 0; x < 50; x++) {
            landscape[y][x] = from(line[x]);
            std::cout << (char)landscape[y][x];
        }
        std::cout << std::endl;
        y++;
    }
}