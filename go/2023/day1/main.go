package main

import (
	"bufio"
	"fmt"
	"os"
	"sync"
)

func main() {
	ans := part1(false)

	fmt.Println("part 1 answer:")
	fmt.Println(ans)
	fmt.Println("-----------------------")

	ans = part2(true)
	fmt.Println("part 2 answer:")
	fmt.Println(ans)
	fmt.Println("-----------------------")

}

func part1(test bool) int {
	var file *os.File
	var err error
	if test {
		file, err = os.Open("./data/test.data")

		if err != nil {
			panic(err)
		}
	} else {
		file, _ = os.Open("./data/real.data")
	}
	defer file.Close()

	fileScanner := bufio.NewScanner(file)
	fileScanner.Split(bufio.ScanLines)

	wg := &sync.WaitGroup{}
	strChan := make(chan string)
	intChan := make(chan int)
	go process(strChan, intChan, wg)
	for fileScanner.Scan() {
		line := fileScanner.Text()
		wg.Add(1)
		go func() {
			strChan <- line
		}()
	}
	fmt.Println("closing... strChan")
	fmt.Println("closed... strChan")
	go func() {
		wg.Wait()
		close(strChan)
	}()
	sum := 0
	for i := range intChan {
		sum += i
	}

	return sum
}

func process(strChan chan string, intChan chan int, wg *sync.WaitGroup) {
	for line := range strChan {
		tens := 10
		ones := 1
		for _, r := range line {
			if r >= '0' && r <= '9' {
				tens *= int(r - '0')
				break
			}
		}
		for _, r := range Reverse(line) {
			if r >= '0' && r <= '9' {
				ones *= int(r - '0')
				break
			}
		}
		go func() {
			intChan <- (tens + ones)
			wg.Done()
		}()
	}
	close(intChan)
}

func Reverse(s string) string {
	r := []rune(s)
	for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
		r[i], r[j] = r[j], r[i]
	}
	return string(r)
}

func part2(test bool) int {
	var file *os.File
	if test {
		file, _ = os.Open("./data/test.data")
	} else {
		file, _ = os.Open("./data/real.data")
	}
	file.Close()
	return 0
}
