library(stringr)

H <- 103
W <- 101

simulate <- function(robots, seconds) {
  positions <- lapply(robots, \(robot) c((robot[1] + seconds * robot[3]) %% W, (robot[2] + seconds * robot[4]) %% H))

  return(positions)
}

part1 <- function(robots) {
  positions <- simulate(robots, 100)

  quadrants <- matrix(0, 2, 2)

  borderX <-  as.integer((W - 1) / 2)
  borderY <-  as.integer((H - 1) / 2)

  for (pos in positions) {
    if (pos[1] < borderX) {
      if (pos[2] < borderY) {
        quadrants[1, 1] <- quadrants[1, 1] + 1
      } else if (pos[2] > borderY){
        quadrants[1, 2] <- quadrants[1, 2] + 1
      }
    } else if (pos[1] > borderX) {
      if (pos[2] < borderY) {
        quadrants[2, 1] <- quadrants[2, 1] + 1
      } else if (pos[2] > borderY){
        quadrants[2, 2] <- quadrants[2, 2] + 1
      }
    }
  }

  return(prod(quadrants))
}

part2 <- function(robots) {
  for (t in 1: (H * W)) {
    positions <- simulate(robots, t)

    counts <- matrix(0, H, W)
    for (pos in positions) {
      counts[pos[2], pos[1]] <- counts[pos[2], pos[1]] + 1
    }

    if (max(unlist(counts)) == 1){
      return(t)
    }
  }

  return(-1)
}

f <- file("inputs/day14", "r")
lines <- readLines(f)
close(f)

robots <- lapply(lines, \(line) as.numeric(str_match(line, "p=(\\d+),(\\d+) v=(-?\\d+),(-?\\d+)")[-1]))

print(part1(robots))
print(part2(robots))
