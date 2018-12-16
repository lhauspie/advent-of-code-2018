package main

import (
	"sort"
)

type Point struct {
	X int
	Y int
}

type PointWithMemory struct {
	Point
	path  []Point
	found bool
}

type PointsWithMemory []PointWithMemory

func (pwm PointsWithMemory) Less(i, j int) bool {
	iPathLen := len(pwm[i].path)
	jPathLen := len(pwm[j].path)
	if iPathLen != jPathLen {
		return iPathLen < jPathLen
	}
	// Here both pointsWithMemory have a path of the same size
	if iPathLen == 0 {
		return true
	}
	// Here both pointsWithMemory have a non-empty path of the same size
	iLastPoint := pwm[i].path[iPathLen-1]
	jLastPoint := pwm[j].path[jPathLen-1]
	if iLastPoint.Y != jLastPoint.Y {
		return iLastPoint.Y < jLastPoint.Y
	}
	return iLastPoint.X < jLastPoint.X
}
func (pwm PointsWithMemory) Len() int      { return len(pwm) }
func (pwm PointsWithMemory) Swap(i, j int) { pwm[i], pwm[j] = pwm[j], pwm[i] }

func (p Point) IsAdjacent(other Point) bool {
	return Point{p.X + 1, p.Y} == other ||
		Point{p.X - 1, p.Y} == other ||
		Point{p.X, p.Y - 1} == other ||
		Point{p.X, p.Y + 1} == other
}

func (p Point) Up() Point {
	return Point{p.X, p.Y - 1}
}

func (p Point) Down() Point {
	return Point{p.X, p.Y + 1}
}

func (p Point) Left() Point {
	return Point{p.X - 1, p.Y}
}

func (p Point) Right() Point {
	return Point{p.X + 1, p.Y}
}

type Unit struct {
	Alive       bool
	Position    Point
	Symbol      byte
	EnemySymbol byte
	HitPoint    int
	AttackPower int
}

func NewUnit(x, y int, symbol, enemySymbol byte, attackPower int) *Unit {
	return &Unit{
		Alive:       true,
		Position:    Point{x, y},
		Symbol:      symbol,
		EnemySymbol: enemySymbol,
		HitPoint:    200,
		AttackPower: attackPower,
	}
}

func (u *Unit) Attack(other *Unit) {
	other.HitPoint -= u.AttackPower
	if other.HitPoint <= 0 {
		other.Alive = false
	}
}

type Units []*Unit

func (u Units) Less(i, j int) bool {
	if u[i].Position.Y == u[j].Position.Y {
		return u[i].Position.X < u[j].Position.X
	}
	return u[i].Position.Y < u[j].Position.Y
}
func (u Units) Len() int      { return len(u) }
func (u Units) Swap(i, j int) { u[i], u[j] = u[j], u[i] }

// Call this function only if there is no enemy in range
func (u *Unit) FindPathToClosestEnemy(caveWithUnits Cave) []Point {
	// COPY THE CAVE TO EXPLORE IT
	caveCopy := make(Cave, len(caveWithUnits))
	for y := range caveCopy {
		caveCopy[y] = make([]byte, len(caveWithUnits[y]))
		copy(caveCopy[y], caveWithUnits[y])
	}

	pointsWithMemory := []PointWithMemory{
		PointWithMemory{u.Position, make([]Point, 0), false},
	}
	pointsWithMemory = findPathesToClosestEnemies(&caveCopy, u.EnemySymbol, pointsWithMemory)

	// Filter by is this path allow to find an enemy?
	foundPointsWithMemory := make(PointsWithMemory, 0)
	for i := range pointsWithMemory {
		if pointsWithMemory[i].found {
			foundPointsWithMemory = append(foundPointsWithMemory, pointsWithMemory[i])
		}
	}
	// No enemy found
	if len(foundPointsWithMemory) == 0 {
		return []Point{}
	}

	// sort this list by the last point (by Y and then by X)
	sort.Sort(foundPointsWithMemory)
	return foundPointsWithMemory[0].path
}

func findPathesToClosestEnemies(caveWithUnits *Cave, symbol byte, points []PointWithMemory) []PointWithMemory {
	enemyFound := false

	nextPoints := make([]PointWithMemory, 0)

	for _, point := range points {
		var dest Point
		// explore up
		dest = point.Up()
		if caveWithUnits.IsAvailable(dest) {
			(*caveWithUnits)[dest.Y][dest.X] = 'X'
			nextPoints = append(nextPoints, newPointWithMemory(point, dest))
		} else if caveWithUnits.IsOccupiedBy(dest, symbol) {
			point.found = true
			nextPoints = append(nextPoints, point)
			enemyFound = true
		}

		// explore left
		dest = point.Left()
		if caveWithUnits.IsAvailable(dest) {
			(*caveWithUnits)[dest.Y][dest.X] = 'X'
			nextPoints = append(nextPoints, newPointWithMemory(point, dest))
		} else if caveWithUnits.IsOccupiedBy(dest, symbol) {
			point.found = true
			nextPoints = append(nextPoints, point)
			enemyFound = true
		}

		// explore right
		dest = point.Right()
		if caveWithUnits.IsAvailable(dest) {
			(*caveWithUnits)[dest.Y][dest.X] = 'X'
			nextPoints = append(nextPoints, newPointWithMemory(point, dest))
		} else if caveWithUnits.IsOccupiedBy(dest, symbol) {
			point.found = true
			nextPoints = append(nextPoints, point)
			enemyFound = true
		}

		// explore down
		dest = point.Down()
		if caveWithUnits.IsAvailable(dest) {
			(*caveWithUnits)[dest.Y][dest.X] = 'X'
			nextPoints = append(nextPoints, newPointWithMemory(point, dest))
		} else if caveWithUnits.IsOccupiedBy(dest, symbol) {
			point.found = true
			nextPoints = append(nextPoints, point)
			enemyFound = true
		}
	}

	if enemyFound || len(nextPoints) == 0 {
		return nextPoints
	}
	return findPathesToClosestEnemies(caveWithUnits, symbol, nextPoints)
}

func newPointWithMemory(currentPoint PointWithMemory, dest Point) PointWithMemory {
	newPoint := PointWithMemory{
		Point{dest.X, dest.Y},
		make([]Point, len(currentPoint.path)),
		false,
	}
	copy(newPoint.path, currentPoint.path)
	newPoint.path = append(newPoint.path, dest)
	return newPoint
}

func (u *Unit) IsInRangeOfEnemy(caveWithUnits Cave) bool {
	return caveWithUnits[u.Position.Y+1][u.Position.X] == u.EnemySymbol ||
		caveWithUnits[u.Position.Y-1][u.Position.X] == u.EnemySymbol ||
		caveWithUnits[u.Position.Y][u.Position.X-1] == u.EnemySymbol ||
		caveWithUnits[u.Position.Y][u.Position.X+1] == u.EnemySymbol
}
