package main

import (
	"bufio"
	"container/heap"
	"fmt"
	"math"
	"os"
	"slices"
)

var dX = [...]int{1, 0, -1, 0}
var dY = [...]int{0, 1, 0, -1}

type Pos struct {
	y, x int
}

type State struct {
	pos Pos
	dir int

	cost  int
	index int
}

type PriorityQueue []*State

func (pq PriorityQueue) Len() int { return len(pq) }
func (pq PriorityQueue) Less(i, j int) bool {
	return pq[i].cost < pq[j].cost
}

func (pq PriorityQueue) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}

func (pq *PriorityQueue) Push(x any) {
	n := len(*pq)
	item := x.(*State)
	item.index = n
	*pq = append(*pq, item)
}

func (pq *PriorityQueue) Pop() any {
	old := *pq
	n := len(old)
	item := old[n-1]
	old[n-1] = nil
	item.index = -1
	*pq = old[0 : n-1]
	return item
}

func (pq *PriorityQueue) update(item *State, pos Pos, dir int, cost int) {
	item.pos = pos
	item.dir = dir
	item.cost = cost
	heap.Fix(pq, item.index)
}

func dijkstra(maze [][]rune) [][][]int {
	startY, startX := 0, 0
	endY, endX := 0, 0

	for y, row := range maze {
		for x, char := range row {
			if char == 'S' {
				startY = y
				startX = x
			} else if char == 'E' {
				endY = y
				endX = x
			}
		}
	}

	costs := make([][][]int, len(maze))
	for i := range costs {
		costs[i] = make([][]int, len(maze[i]))
		for j := range costs[i] {
			costs[i][j] = make([]int, 4)
			for k := range costs[i][j] {
				costs[i][j][k] = math.MaxInt
			}
		}
	}

	pq := make(PriorityQueue, 0)
	heap.Init(&pq)
	heap.Push(&pq, &State{pos: Pos{startY, startX}, dir: 0, cost: 0})

	minCost := math.MaxInt

	for pq.Len() > 0 {
		state := heap.Pop(&pq).(*State)
		if costs[state.pos.y][state.pos.x][state.dir] < state.cost &&
			costs[state.pos.y][state.pos.x][state.dir] != -1 {
			continue
		}

		if state.cost > minCost {
			break
		}

		costs[state.pos.y][state.pos.x][state.dir] = state.cost

		if state.pos.y == endY && state.pos.x == endX {
			if minCost > state.cost {
				minCost = state.cost
			}
		}

		newPos := Pos{state.pos.y + dY[state.dir], state.pos.x + dX[state.dir]}

		if maze[newPos.y][newPos.x] != '#' {
			heap.Push(&pq, &State{pos: newPos, dir: state.dir, cost: state.cost + 1})
		}

		heap.Push(&pq, &State{pos: state.pos, dir: (state.dir + 1) % 4, cost: state.cost + 1000})
		heap.Push(&pq, &State{pos: state.pos, dir: (state.dir + 3) % 4, cost: state.cost + 1000})
	}

	return costs
}

func part1(maze [][]rune, costs [][][]int) int {
	for y, row := range maze {
		for x, char := range row {
			if char == 'E' {
				return slices.Min(costs[y][x])
			}
		}
	}

	return 0
}

func walk(costs [][][]int, visited *[]Pos, y int, x int, dir int) {
	if costs[y][x][dir] == -1 {
		return
	}

	if !slices.Contains(*visited, Pos{y, x}) {
		*visited = append(*visited, Pos{y, x})
	}
	currentCost := costs[y][x][dir]

	prev := costs[y-dY[dir]][x-dX[dir]][dir]
	if prev+1 == currentCost && prev != -1 {
		walk(costs, visited, y-dY[dir], x-dX[dir], dir)
	}

	prev = costs[y][x][(dir+1)%4]
	if prev+1000 == currentCost && prev != -1 {
		walk(costs, visited, y, x, (dir+1)%4)
	}

	prev = costs[y][x][(dir+3)%4]
	if prev+1000 == currentCost && prev != -1 {
		walk(costs, visited, y, x, (dir+3)%4)
	}
}

func part2(maze [][]rune, costs [][][]int) int {
	for y, row := range maze {
		for x, char := range row {
			if char == 'E' {
				minCost := slices.Min(costs[y][x])
				visited := make([]Pos, 0)

				for dir := range 4 {
					if costs[y][x][dir] == minCost {
						walk(costs, &visited, y, x, dir)
					}
				}

				return len(visited)
			}
		}
	}

	return 0
}

func main() {
	file, _ := os.Open("inputs/day16")
	defer file.Close()

	maze := make([][]rune, 0)

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		row := make([]rune, len(line))
		for i, r := range line {
			row[i] = r
		}
		maze = append(maze, row)
	}

	costs := dijkstra(maze)

	fmt.Println(part1(maze, costs))
	fmt.Println(part2(maze, costs))
}
