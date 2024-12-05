package main

import (
	_ "embed"
	"fmt"
	"math"
	"slices"
	"sort"
	"strconv"
	"strings"

	"github.com/catdevman/aoc/internal"
)

//go:embed data/test.data
var testContent string

//go:embed data/real.data
var realContent string

func main() {
	sum := 0
	for i, r := range testContent {
		fmt.Println(i, r)
	}

	fmt.Println("answer for part 1:", sum)
	fmt.Println("==========")
	sum = 0
	for _, line := range testContent {
	}
	fmt.Println("answer for part 2:", sum)

}

func isSafe(nums []int) bool {
	safe := true
	incOrDec := slices.IsSorted(nums) || sort.SliceIsSorted(nums, func(i, j int) bool {
		fmt.Println("j:", j, nums[j], "i:", i, nums[i])
		return nums[j] >= nums[i]
	})
	for i := 0; i < len(nums)-1; i++ {
		diff := int(math.Abs(float64(nums[i] - nums[i+1])))
		if diff < 0 || diff > 3 {
			safe = false
		}
	}
	return safe && incOrDec
}

func isCountedSafe(nums []int) bool {
	safe := false
	for i := 0; i < len(nums)-1; i++ {
		tmp := make([]int, len(nums))
		copy(tmp, nums)
		comp := append(tmp[:i], tmp[i+1:]...)
		fmt.Println(tmp)
		if isSafe(comp) {
			safe = true
		}
	}
	return safe
}
