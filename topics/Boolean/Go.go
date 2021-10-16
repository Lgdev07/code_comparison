package main

import "fmt"

func main() {
	fmt.Println(true && false) // false
	fmt.Println(true || false) // true
	fmt.Println(!true)         // false

	// Go doesn't have a quick way to evaluate if something is "truthy"
	x := 1
	if x != 0 {
		fmt.Println("Yes")
	}
	var y []string
	if len(y) != 0 {
		fmt.Println("this won't be printed")
	}
}
