package main

import (
	"os"
)

func main() {
	f, _ := os.Open("defer.go")
	defer f.Close()
}
