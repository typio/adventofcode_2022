package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type Knot struct {
	x int
	y int
}

const knots_count = 10

func move_rope(knots [knots_count]Knot) [knots_count]Knot {
	for i := 1; i < len(knots); i++ {
		knots[i] = move_knot(knots[i], knots[i-1])
	}
	return knots
}

func move_knot(tail Knot, newHead Knot) Knot {
	newX, newY := tail.x, tail.y

	if tail.x-newHead.x < -1 {
		newX = tail.x + 1
		if tail.y < newHead.y {
			newY = tail.y + 1
		} else if tail.y > newHead.y {
			newY = tail.y - 1
		}
	} else if tail.x-newHead.x > 1 {
		newX = tail.x - 1
		if tail.y < newHead.y {
			newY = tail.y + 1
		} else if tail.y > newHead.y {
			newY = tail.y - 1
		}
	}

	if tail.y-newHead.y < -1 {
		newY = tail.y + 1
		if tail.x < newHead.x {
			newX = tail.x + 1
		} else if tail.x > newHead.x {
			newX = tail.x - 1
		}
	} else if tail.y-newHead.y > 1 {
		newY = tail.y - 1
		if tail.x < newHead.x {
			newX = tail.x + 1
		} else if tail.x > newHead.x {
			newX = tail.x - 1
		}
	}

	return Knot{newX, newY}
}

func main() {
	file, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	knots := [knots_count]Knot{}

	tailPositions := make(map[Knot]struct{})

	draw_x_range := [2]int{-20, 20}
	draw_y_range := [2]int{-20, 20}

	for scanner.Scan() {
		tokens := strings.Fields(scanner.Text())
		direction := tokens[0]
		n_steps, err := strconv.Atoi(tokens[1])
		if err != nil {
			fmt.Println("Failed to parse number of steps")
			return
		}

		tailPositions[knots[len(knots)-1]] = struct{}{}
		for i := 1; i <= n_steps; i++ {
			tailPositions[knots[len(knots)-1]] = struct{}{}
			switch direction {
			case "R":
				knots[0].x++
			case "L":
				knots[0].x--
			case "U":
				knots[0].y++
			case "D":
				knots[0].y--
			}
			knots = move_rope(knots)
			tailPositions[knots[len(knots)-1]] = struct{}{}
			// fmt.Print("\033[H\033[2J")

			// for i := draw_y_range[1]; i >= draw_y_range[0]; i-- {
			// 	for j := draw_x_range[0]; j <= draw_x_range[1]; j++ {
			// 		c := "."
			// 		for k := 0; k < len(knots); k++ {
			// 			if knots[k].x == j && knots[k].y == i {
			// 				c = strconv.Itoa(k)
			// 			}
			// 		}
			// 		if i == 0 && j == 0 {
			// 			c = "s"
			// 		}
			// 		fmt.Print(c)
			// 	}
			// 	fmt.Println()
			// }
			// fmt.Println()
		}
		// fmt.Println("==========================================================================")
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println(len(tailPositions))
	for i := draw_y_range[1]; i >= draw_y_range[0]; i-- {
		for j := draw_x_range[0]; j <= draw_x_range[1]; j++ {
			if i == 0 && j == 0 {
				fmt.Print("s")
			} else if _, ok := tailPositions[Knot{j, i}]; ok {
				fmt.Print("#")
			} else {
				fmt.Print(".")
			}
		}
		fmt.Println()
	}

}
