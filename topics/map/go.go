package main

import "fmt"

func main() {
	population := map[string]int{
		"China": 1411778724,
		"India": 1381230134,
		"USA":   332271672,
	}
	fmt.Println(population["USA"]) // 332271672

	// add new key
	population["Brazil"] = 22

	// delete by key
	delete(population, "Brazil")

	// Checking if a key exists in a map
	country, ok := population["India"]
	fmt.Println(country, ok) // 1381230134, true

	country, ok = population["Italy"]
	fmt.Println(country, ok) // 0, false

	// Iterating over a map

	for index, value := range population {
		fmt.Println(index, value)
	}
	// Output:
	// China 1411778724
	// India 1381230134
	// USA 332271672
}
