package main

import "fmt"

type Cave [][]byte

func NewCave(lines []string) Cave {
	cave := make(Cave, len(lines))
	for y := range cave {
		cave[y] = []byte(lines[y])
		for x, char := range lines[y] {
			if char == 'G' || char == 'E' {
				cave[y][x] = '.'
			}
		}
	}
	return cave
}

func (c Cave) Display() {
	fmt.Println("==================================")
	for y := range c {
		for x := range c[y] {
			fmt.Printf("%c", c[y][x])
		}
		fmt.Println("")
	}
}

func (c Cave) IsAvailable(p Point) bool {
	return c[p.Y][p.X] == '.'
}

func (c Cave) IsOccupiedBy(p Point, symbol byte) bool {
	return c[p.Y][p.X] == symbol
}
