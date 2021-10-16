package main

import "fmt"

func main() {
	// Array
	// An array's length is part of its type, so arrays cannot be resized.

	// Create an array
	var array [3]int // becomes [0, 0, 0]
	// Change one of them
	array[1] = 20
	// Length of it
	fmt.Println(len(array)) // 3

	// Slice
	// A slice, on the other hand, is a dynamically-sized

	// Lets create a new slice based on the array
	new_list := array[0:2]
	fmt.Println(new_list) // [0, 20]
	// append a new value
	new_list = append(new_list, 20)
	fmt.Println(new_list) // [0, 20, 20]
}
