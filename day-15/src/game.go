package main

import (
	"fmt"
	"sort"
)

type Game struct {
	Cave Cave
	// Elves         Units
	// Goblins       Units
	Units         Units
	CaveWithUnits Cave
}

func NewGame(lines []string, elveAttackPower, goblinAttackPower int) *Game {
	game := &Game{}
	game.Cave = NewCave(lines)
	game.CaveWithUnits = NewCave(lines)

	for y := range lines {
		for x, char := range []byte(lines[y]) {
			if char == 'G' || char == 'E' {
				game.CaveWithUnits[y][x] = char
				if char == 'G' {
					unit := NewUnit(x, y, char, 'E', goblinAttackPower)
					game.Units = append(game.Units, unit)
				}
				if char == 'E' {
					unit := NewUnit(x, y, char, 'G', elveAttackPower)
					game.Units = append(game.Units, unit)
				}
			}
		}
	}
	return game
}

func (g *Game) Display() {
	g.CaveWithUnits.Display()
	for _, unit := range g.Units {
		fmt.Printf("Unit %c (%v,%v) health: %v \n", unit.Symbol, unit.Position.X, unit.Position.Y, unit.HitPoint)
	}
}

func (g *Game) IsAvailable(p Point) bool {
	return g.Cave.IsAvailable(p) && !g.otherUnit(p)
}

func (g *Game) otherUnit(p Point) bool {
	for _, unit := range g.Units {
		if unit.Position == p {
			return true
		}
	}
	return false
}

func (g *Game) RoundUp() bool {
	sort.Sort(g.Units)
	targetFound := false
	for _, unit := range g.Units {
		if unit.Alive {
			if !unit.IsInRangeOfEnemy(g.CaveWithUnits) {
				pathToClosestEnemy := unit.FindPathToClosestEnemy(g.CaveWithUnits)
				if len(pathToClosestEnemy) == 0 {
					// END OF TURN FOR THIS UNIT : NO REACHABLE TARGET
				} else {
					targetFound = true
					g.CaveWithUnits[unit.Position.Y][unit.Position.X] = '.'
					unit.Position = pathToClosestEnemy[0]
					g.CaveWithUnits[unit.Position.Y][unit.Position.X] = unit.Symbol
				}
			}
			// The situation has maybed changed, so we check again the InRange
			if unit.IsInRangeOfEnemy(g.CaveWithUnits) {
				targetFound = true
				weakestEnemy := g.GetWeakestEnemy(unit, g.CaveWithUnits)
				unit.Attack(weakestEnemy)
				if !weakestEnemy.Alive {
					g.CaveWithUnits[weakestEnemy.Position.Y][weakestEnemy.Position.X] = '.'
				}
			}
		}
	}

	return targetFound
}

// Call this function only if you know that there is an enemy in range
func (g *Game) GetWeakestEnemy(unit *Unit, CaveWithUnits Cave) *Unit {
	enemies := make(Units, 0)
	for i := range g.Units {
		if g.Units[i].Alive && g.Units[i].Symbol != unit.Symbol {
			enemyPosition := g.Units[i].Position
			if unit.Position.Up() == enemyPosition ||
				unit.Position.Down() == enemyPosition ||
				unit.Position.Left() == enemyPosition ||
				unit.Position.Right() == enemyPosition {
				enemies = append(enemies, g.Units[i])
			}
		}
	}

	sort.Sort(enemies)
	weakest := enemies[0]
	for i := range enemies {
		if enemies[i].HitPoint < weakest.HitPoint {
			weakest = enemies[i]
		}
	}

	return weakest
}
