package main

import (
	_ "embed"
	"fmt"
	"math"
	"regexp"
	"strings"
)

//go:embed data/test.data
var testContent string

//go:embed data/real.data
var realContent string

func main() {

	sum := 0
	content := realContent
	checks := strings.Split(content, "mul(")
	for _, next := range checks {
		re := regexp.MustCompile(`^\d+\,\d+\)`)
		res := re.Find([]byte(next))
		if len(res) == 0 {
			continue
		}
		idx := 0
		for true {
			if res[idx] == ',' {
				break
			}
			idx++
		}
		num1 := getInt(res[:idx])
		num2 := getInt(res[idx+1 : len(res)-1])
		sum += (num1 * num2)

	}

	fmt.Println("answer for part 1:", sum)
	fmt.Println("==========")
	sum = 0
	enabled := true
	for i := 0; i < len(content); i++ {
		x := 0
		y := 0
		if isNext(content, i, "do()") {
			enabled = true
		} else if isNext(content, i, "don't()") {
			enabled = false
		} else if isNext(content, i, "mul(") {
			j := i + 4 //minimum amount before ')'
			for content[j] != ')' {
				if content[j] == 'm' {
					break
				}
				j++
			}

			re := regexp.MustCompile(`\d+`)
			matches := re.FindAll([]byte(content[i:j+1]), 3)
			if matches != nil && len(matches) == 2 {
				x, y = getInt(matches[0]), getInt(matches[1])
				if _, ok := mapping[byte(content[j-1])]; !ok {
					continue
				}
			} else {
				continue
			}
			if enabled {
				sum += x * y
			}
		}

	}
	fmt.Println("answer for part 2:", sum)
}

func isNext(content string, idx int, comp string) bool {

	if idx+len(comp) > len(content) {
		return false
	}
	return string(content[idx:idx+len(comp)]) == comp
}

var mapping map[byte]int = map[byte]int{
	48: 0,
	49: 1,
	50: 2,
	51: 3,
	52: 4,
	53: 5,
	54: 6,
	55: 7,
	56: 8,
	57: 9,
}

func getInt(s []byte) int {
	var res int
	place := int(math.Pow10(len(s) - 1))
	for _, v := range s {
		// fmt.Println("mapping & place:", mapping[v], place)
		res += mapping[v] * place
		place /= 10
	}
	return res
}
