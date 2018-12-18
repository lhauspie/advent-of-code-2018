// read_file.cpp: Logan HAUSPIE
// read the input.txt file line by line and then display to stdout

#include <fstream>
#include <sstream>
#include <string>
#include <iostream>


int main() {
    std::ifstream infile("input.txt");
    std::string line;

    while (std::getline(infile, line)) {
        std::cout << line << std::endl;
    }
}