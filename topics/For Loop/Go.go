package main

import "fmt"

func main() {
	// classic for
	sum := 0
	for i := 0; i < 10; i++ {
		sum += i
	}
	fmt.Println(sum)

	// while
	sum = 1
	for sum < 1000 {
		sum += sum
	}
	fmt.Println(sum)

	// range
	bestGames := []string{
		"Tetris",
		"Pacman",
		"Mario",
	}

	for index, value := range bestGames {
		fmt.Printf("%d. %s\n", index+1, value)
	}
	// 1. Tetris
	// 2. Pacman
	// 3. Mario
}
