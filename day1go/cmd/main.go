package main

import (
	"fmt"
	elf_factory "ling/advent22/day1"
	"sort"
)

func main() {
	er := elf_factory.NewElfReader()

	elves, err := er.GetElfArray("../assets/elf_data.txt")

	if err != nil {
		fmt.Print(err)
	}

	sort.Slice(elves, func(i, j int) bool {
		return elves[i].Calories > elves[j].Calories
	})

	alphaElves := 0

	for _, alpha := range elves[:3] {
		alphaElves += alpha.Calories
	}

	fmt.Println()
	fmt.Printf("AlphaElfs is carrying %d calories", alphaElves)
	fmt.Println()
}
