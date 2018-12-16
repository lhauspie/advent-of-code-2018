package main

import (
	"sort"
	"testing"
)

func TestPointEquality(t *testing.T) {
	firstPoint := Point{1, 1}
	secondPoint := Point{1, 1}

	if firstPoint != secondPoint {
		t.Errorf("Both points should be equal")
	}
}

func TestPointAreAdjecant(t *testing.T) {
	firstPoint := Point{1, 2}
	secondPoint := Point{1, 1}

	if !firstPoint.IsAdjacent(secondPoint) {
		t.Errorf("Both points should be adjacent")
	}
}

func TestNewUnit(t *testing.T) {
	testCases := []struct {
		name                string
		unit                *Unit
		expectedAlive       bool
		expectedHitPoint    int
		expectedAttackPower int
	}{
		{"Elve", NewUnit(0, 0, 'E', 'G', 3), true, 200, 3},
		{"Goblin", NewUnit(0, 0, 'G', 'E', 3), true, 200, 3},
		{"Other", NewUnit(0, 0, 'H', 'I', 3), true, 200, 3},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			if tc.expectedAlive != tc.unit.Alive {
				t.Errorf("expected %v, but got %v", tc.expectedAlive, tc.unit.Alive)
			}
			if tc.expectedHitPoint != tc.unit.HitPoint {
				t.Errorf("expected %v, but got %v", tc.expectedHitPoint, tc.unit.HitPoint)
			}
			if tc.expectedAttackPower != tc.unit.AttackPower {
				t.Errorf("expected %v, but got %v", tc.expectedAttackPower, tc.unit.AttackPower)
			}
		})
	}
}

func TestSortUnits(t *testing.T) {
	units := make(Units, 0, 6)
	units = append(units, NewUnit(3, 1, 'G', 'E', 3))
	units = append(units, NewUnit(2, 1, 'G', 'E', 3))
	units = append(units, NewUnit(1, 1, 'E', 'G', 3))
	units = append(units, NewUnit(5, 2, 'E', 'G', 3))
	units = append(units, NewUnit(8, 8, 'G', 'E', 3))
	units = append(units, NewUnit(4, 8, 'G', 'E', 3))

	positions := make([]Point, 0, 6)
	positions = append(positions, Point{1, 1})
	positions = append(positions, Point{2, 1})
	positions = append(positions, Point{3, 1})
	positions = append(positions, Point{5, 2})
	positions = append(positions, Point{4, 8})
	positions = append(positions, Point{8, 8})

	sort.Sort(units)
	for i, u := range units {
		if u.Position != positions[i] {
			t.Errorf("expected %v, but got %v", positions[i], u.Position)
		}
	}
}

func TestFindPathToClosestElveEnemy(t *testing.T) {
	game := NewGame([]string{
		"##########",
		"##.G....##",
		"##...#####",
		"####..E.##",
		"##########",
	}, 3, 3)

	pathToClosestEnemy := game.Units[1].FindPathToClosestEnemy(game.CaveWithUnits)

	expected := []Point{
		Point{5, 3},
		Point{4, 3},
		Point{4, 2},
		Point{4, 1},
	}

	for i := range expected {
		if expected[i] != pathToClosestEnemy[i] {
			t.Errorf("expected %v, but got %v", expected[i], pathToClosestEnemy[i])
		}
	}
}

func TestFindPathToClosestGoblinEnemy(t *testing.T) {
	game := NewGame([]string{
		"##########",
		"##.G....##",
		"##...#####",
		"####..E.##",
		"##########",
	}, 3, 3)

	pathToClosestEnemy := game.Units[0].FindPathToClosestEnemy(game.CaveWithUnits)

	expected := []Point{
		Point{4, 1},
		Point{4, 2},
		Point{4, 3},
		Point{5, 3},
	}

	for i := range expected {
		if expected[i] != pathToClosestEnemy[i] {
			t.Errorf("expected %v, but got %v", expected[i], pathToClosestEnemy[i])
		}
	}
}
