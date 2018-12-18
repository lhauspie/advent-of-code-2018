
#include <fstream>
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


void init_landscape(Acre landscape[50][50], std::string filename) {
    std::ifstream infile(filename);
    std::string line;

    int y = 0;
    while (std::getline(infile, line)) {
        for (int x = 0; x < 50; x++) {
            landscape[y][x] = from(line[x]);
        }
        y++;
    }
}

void display(Acre landscape[50][50]) {
    for (int y = 0; y < 50; y++) {
        for (int x = 0; x < 50; x++) {
            std::cout << (char)landscape[y][x];
        }
        std::cout << std::endl;
    }
    std::cout << "---------------------------------------------------------------------------------------" << std::endl;
}

void copy(Acre src[50][50], Acre dest[50][50]) {
    for (int y = 0; y < 50; y++) {
        for (int x = 0; x < 50; x++) {
            dest[y][x] = src[y][x];
        }
    }
}


int count_arround(Acre landscape[50][50], int x , int y, Acre search) {
    // std::cout << "counting " << (char)c << std::endl;
    int start_y = std::max(0, y - 1);
    int start_x = std::max(0, x - 1);
    int end_y = std::min(49, y + 1);
    int end_x = std::min(49, x + 1);
    
    int count = 0;
    for (int an_y = start_y; an_y <= end_y; an_y++) {
        for (int an_x = start_x; an_x <= end_x; an_x++) {
            if ((an_x != x) || (an_y != y)) {
                if (landscape[an_y][an_x] == search) {
                    count++;
                }
            }
        }
    }

    return count;
}

int count(Acre landscape[50][50], Acre search) {
    int count = 0;
    for (int y = 0; y < 50; y++) {
        for (int x = 0; x < 50; x++) {
            if (landscape[y][x] == search) {
                count++;
            }
        }
    }
    return count;
}

void calculate_result(Acre landscape[50][50]) {
    int wooded_acres = count(landscape, Acre::tree);
    int lumberyards = count(landscape, Acre::lumberyard);
    int resource_value = wooded_acres * lumberyards;

    // std::cout << "wooded_acres : " << wooded_acres << std::endl;
    // std::cout << "lumberyards : " << lumberyards << std::endl;
    std::cout << "resource_value : " << resource_value << std::endl;
}

int main() {
    int DURATION = 1000000000;
    
    Acre landscape[50][50] = {};
    init_landscape(landscape, "input.txt");
    // std::cout << "Initial state:" << std::endl;
    // display(landscape);

    Acre next_landscape[50][50] = {};
    for (int i = 1; i <= DURATION; i++) {
        for (int y = 0; y < 50; y++) {
            for (int x = 0; x < 50; x++) {
                if (landscape[y][x] == Acre::open) {
                    if (count_arround(landscape, x, y, Acre::tree) >= 3) {
                        next_landscape[y][x] = Acre::tree;
                    } else {
                        next_landscape[y][x] = landscape[y][x];
                    }
                }
                if (landscape[y][x] == Acre::tree) {
                    if (count_arround(landscape, x, y, Acre::lumberyard) >= 3) {
                        next_landscape[y][x] = Acre::lumberyard;
                    } else {
                        next_landscape[y][x] = landscape[y][x];
                    }
                }
                if (landscape[y][x] == Acre::lumberyard) {
                    if (count_arround(landscape, x, y, Acre::lumberyard) >= 1 && count_arround(landscape, x, y, Acre::tree) >= 1) {
                        next_landscape[y][x] = landscape[y][x];
                    } else {
                        next_landscape[y][x] = Acre::open;
                    }
                }
            }
        }
        copy(next_landscape, landscape);

        if (i == 10) { // result of puzzle 1
            calculate_result(landscape);
        }

        if (i > 600 && (i % 28) == 20) { // this part was calculated manually by displaying the landscapes
            calculate_result(landscape);
            i = DURATION; // exit the loop
        }
    }

    // display(landscape);

    return 0;
}