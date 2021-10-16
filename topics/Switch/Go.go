package main

import (
	"fmt"
)

func main() {
	var number int = 1

	switch number {
	case 1:
		fmt.Println("a")
	case 2:
		fmt.Println("b")
	case 3:
		fmt.Println("c")
	case 4:
		fmt.Println("d")
	default:
		fmt.Printf("I have not found %d\n", number)
	}
}
