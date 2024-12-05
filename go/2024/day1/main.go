package main

import (
	_ "embed"
	"fmt"
	"github.com/catdevman/aoc/internal"
	"math"
	"slices"
	"strconv"
	"strings"
)

//go:embed data/test.data
var testContent string

//go:embed data/real.data
var realContent string

func main() {
	left := []int{}
	right := []int{}

	lines := internal.SplitLines(realContent)

	for _, line := range lines {
		temp := strings.Split(line, " ")
		leftInt, _ := strconv.Atoi(temp[0])
		rightInt, _ := strconv.Atoi(temp[len(temp)-1])
		left = append(left, leftInt)
		right = append(right, rightInt)
	}
	slices.Sort(left)
	slices.Sort(right)
	sum := 0
	for i := 0; i < len(left); i++ {

		sum += int(math.Abs(float64(left[i] - right[i])))
	}
	fmt.Println("part 1 answer:", sum)
	fmt.Println("==========")

	counts := make(map[int]int)
	for _, v := range right {
		if _, ok := counts[v]; !ok {
			counts[v] = 0
		}
		counts[v]++
	}
	sum = 0
	for _, v := range left {
		if c, ok := counts[v]; ok {
			sum += c * v
		}
	}

	fmt.Println("part 2 answer:", sum)
}
