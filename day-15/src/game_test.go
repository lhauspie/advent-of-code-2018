package main

import (
	"testing"
)

func TestNewGame(t *testing.T) {
	game := NewGame([]string{
		"##########",
		"##......##",
		"##...#####",
		"####....##",
		"##########",
	}, 3, 3)

	if len(game.Units) != 0 {
		t.Errorf("this game should have no units but found %v", len(game.Units))
	}
}

func TestNewGameWithUnits(t *testing.T) {
	game := NewGame([]string{
		"##########",
		"##.G....##",
		"##...#####",
		"####..E.##",
		"##########",
	}, 3, 3)

	if len(game.Units) != 2 {
		t.Errorf("this game should have two units but found %v", len(game.Units))
	}
}

func TestNewGameWithMoreUnits(t *testing.T) {
	game := NewGame([]string{
		"##########",
		"##.G..G.##",
		"##...#####",
		"####EEE.##",
		"##########",
	}, 3, 3)

	if len(game.Units) != 5 {
		t.Errorf("this game should have two units but found %v", len(game.Units))
	}
}

func TestRoundUp(t *testing.T) {
	game := NewGame([]string{
		"##########",
		"##.G...G##",
		"##...#####",
		"####..E.##",
		"##########",
	}, 3, 3)

	cave := NewCave([]string{
		"##########",
		"##......##",
		"##...#####",
		"####....##",
		"##########",
	})
	cave[1][4] = 'G'
	cave[1][7] = 'G'
	cave[3][5] = 'E'

	game.RoundUp()

	for y := 0; y < len(game.CaveWithUnits); y++ {
		for x := 0; x < len(game.CaveWithUnits[y]); x++ {
			if game.CaveWithUnits[y][x] != cave[y][x] {
				t.Errorf("expected %c for (%v,%v), but got %c", cave[y][x], x, y, game.CaveWithUnits[y][x])
			}
		}
	}

	for i := 0; i < 70; i++ {
		targetFound := game.RoundUp()
		if targetFound != true {
			t.Errorf("No target found but it not normal !!")
		}
	}

	targetFound := game.RoundUp()
	if targetFound != false {
		t.Errorf("Target found but they all already dies !!")
	}
}
