package main

import (
	"testing"
)

func TestNewCave(t *testing.T) {
	cave := NewCave([]string{
		"##########",
		"##......##",
		"##...#####",
		"####....##",
		"##########",
	})

	expected := [5][10]byte{
		{'#', '#', '#', '#', '#', '#', '#', '#', '#', '#'},
		{'#', '#', '.', '.', '.', '.', '.', '.', '#', '#'},
		{'#', '#', '.', '.', '.', '#', '#', '#', '#', '#'},
		{'#', '#', '#', '#', '.', '.', '.', '.', '#', '#'},
		{'#', '#', '#', '#', '#', '#', '#', '#', '#', '#'},
	}

	for y := 0; y < len(cave); y++ {
		for x := 0; x < len(cave[y]); x++ {
			if cave[y][x] != expected[y][x] {
				t.Errorf("expected %v for (%v,%v), but got %v", expected[y][x], x, y, cave[y][x])
			}
		}
	}
}

func TestNewCaveWithUnits(t *testing.T) {
	cave := NewCave([]string{
		"##########",
		"##.G....##",
		"##...#####",
		"####..E.##",
		"##########",
	})

	expected := [5][10]byte{
		{'#', '#', '#', '#', '#', '#', '#', '#', '#', '#'},
		{'#', '#', '.', '.', '.', '.', '.', '.', '#', '#'},
		{'#', '#', '.', '.', '.', '#', '#', '#', '#', '#'},
		{'#', '#', '#', '#', '.', '.', '.', '.', '#', '#'},
		{'#', '#', '#', '#', '#', '#', '#', '#', '#', '#'},
	}

	for y := 0; y < len(cave); y++ {
		for x := 0; x < len(cave[y]); x++ {
			if cave[y][x] != expected[y][x] {
				t.Errorf("expected %c for (%v,%v), but got %c", expected[y][x], x, y, cave[y][x])
			}
		}
	}
}

func TestPointIsAvailableOnCave(t *testing.T) {
	cave := NewCave([]string{
		"##########",
		"##.G....##",
		"##...#####",
		"####..E.##",
		"##########",
	})

	if cave.IsAvailable(Point{0, 0}) {
		t.Errorf("%v should not be avalaible but it is !", Point{0, 0})
	}
	if !cave.IsAvailable(Point{2, 1}) {
		t.Errorf("%v should be avalaible but it is not !", Point{2, 1})
	}
}
