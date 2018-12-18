// count_in_sub_matrix.cpp: Logan HAUSPIE
// Build a (10,10) matrix and then try to count number occurences of an Acre in a (3,3) submatrix

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

void display(char landscape[10][10]) {
    for (int y = 0; y < 10; y++) {
        for (int x = 0; x < 10; x++) {
            std::cout << (char)landscape[y][x];
        }
        std::cout << std::endl;
    }
}

int count(char landscape[10][10], int x , int y, char c) {
    std::cout << "counting " << c << std::endl;
    int start_y = std::max(0, y - 1);
    int start_x = std::max(0, x - 1);
    int end_y = std::min(9, y + 1);
    int end_x = std::min(9, x + 1);
    
    int count = 0;
    for (int an_y = start_y; an_y <= end_y; an_y++) {
        for (int an_x = start_x; an_x <= end_x; an_x++) {
            if ((an_x != x) || (an_y != y)) {
                if (landscape[an_y][an_x] == c) {
                    // std::cout << c << " found at " << an_x << "|" << an_y << std::endl;
                    count++;
                }
            }
            std::cout << (char)landscape[an_y][an_x];
        }
        std::cout << std::endl;
    }

    return count;
}


int main() {
    std::ifstream infile("input.txt");
    std::string line;

    char landscape[10][10] = {
        {'.', '#', '.', '#', '.', '.', '.', '|', '#', '.'},
        {'.', '.', '.', '.', '.', '#', '|', '#', '#', '|'},
        {'.', '|', '.', '.', '|', '.', '.', '.', '#', '.'},
        {'.', '.', '|', '#', '.', '.', '.', '.', '.', '#'},
        {'#', '.', '#', '|', '|', '|', '#', '|', '#', '|'},
        {'.', '.', '.', '#', '.', '|', '|', '.', '.', '.'},
        {'.', '|', '.', '.', '.', '.', '|', '.', '.', '.'},
        {'|', '|', '.', '.', '.', '#', '|', '.', '#', '|'},
        {'|', '.', '|', '|', '|', '|', '.', '.', '|', '.'},
        {'.', '.', '.', '#', '.', '|', '.', '.', '|', '.'}
    };

    std::cout << count(landscape, 0, 0, '.') << std::endl; // should return 2
    std::cout << count(landscape, 3, 3, '#') << std::endl; // should return 1
    std::cout << count(landscape, 7, 6, '|') << std::endl; // should return 3
    std::cout << count(landscape, 7, 6, '#') << std::endl; // should return 1
    std::cout << count(landscape, 7, 6, '.') << std::endl; // should return 4
}