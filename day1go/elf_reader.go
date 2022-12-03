package elf_factory

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

type ElfReader struct {
}

func NewElfReader() *ElfReader {
	return &ElfReader{}
}

func (e *ElfReader) GetElfArray(dataPath string) ([]Elf, error) {

	file, err := os.Open(dataPath)
	defer file.Close()
	if err != nil {
		return nil, fmt.Errorf("Failed to read Elf data ", err)
	}

	scanner := bufio.NewScanner(file)

	elves := make([]Elf, 0)

	calories := 0
	for scanner.Scan() {
		row := scanner.Text()

		if len(row) == 0 {
			elves = append(elves, Elf{Calories: calories})
			calories = 0
			continue
		}

		c, err := strconv.Atoi(row)
		if err != nil {
			return nil, fmt.Errorf("failed to parse elf data ", err)
		}
		calories = calories + c
	}

	return elves, nil
}

type Elf struct {
	Calories int
}
