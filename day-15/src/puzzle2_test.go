package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"testing"
)

func TestPuzzle2(t *testing.T) {
	file, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	lines := make([]string, 0)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	elvesDied := true
	nbRounds := 0
	elveAttackPower := 3
	var game *Game
	for elvesDied {
		game = NewGame(lines, elveAttackPower, 3)

		nbRounds = 0
		for game.RoundUp() {
			nbRounds++
		}

		elvesDied = ElvesDied(game.Units)
		if elvesDied {
			elveAttackPower++
		}
	}

	sumHealth := 0
	for _, unit := range game.Units {
		if unit.Alive {
			sumHealth += unit.HitPoint
		}
	}

	fmt.Printf("GAME FINISHED After %v rounds \n", nbRounds-1)
	fmt.Printf("Total of HitPoint remaining : %v \n", sumHealth)
	fmt.Printf("So Outcome is : %v \n", sumHealth*(nbRounds-1))
}

func ElvesDied(units Units) bool {
	for _, unit := range units {
		if unit.Symbol == 'E' && unit.Alive == false {
			return true
		}
	}
	return false
}
