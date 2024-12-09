import scala.io.Source
import scala.util.boundary, boundary.break


def checkCombinations(result: Long, operands: List[Long], cases: Int): Boolean = {
  var combination = List.fill(operands.length - 1)(0).toArray
  var valid = false
  var overflow = false

  while (!valid && !overflow){
    var res: Long = operands(0)
    for (i <- 1 to operands.length - 1) {
      if (combination(i - 1) == 0) {
        res = res + operands(i)
      } else if (combination(i - 1) == 1) {
        res = res * operands(i)
      } else if (combination(i - 1) == 2) {
        res = (res.toString + operands(i).toString).toLong
      }
    }

    if (res == result) {
      valid = true
    }

    boundary{
      combination(combination.length - 1) += 1

      for (i <- combination.length - 1 to 0 by -1) {
        if (combination(i) >= cases) {
          combination(i) = 0
          if (i - 1 >= 0){
            combination(i - 1) += 1
          } else {
            overflow = true
          }
        } else {
          break()
        }
      }
    }
  }

  return valid
}

def part1(inputs: List[(Long, List[Long])]): Long = {
  var sum: Long = 0

  inputs.foreach((result, operands) => {
    if (checkCombinations(result, operands, 2)){
      sum += result
    }
  })

  return sum;
}

def part2(inputs: List[(Long, List[Long])]): Long = {
  var sum: Long = 0

  inputs.foreach((result, operands) => {
    if (checkCombinations(result, operands, 3)){
      sum += result
    }
  })

  return sum;
}

@main def day07() =
  val source = Source.fromFile("../inputs/day07")
  var inputs = List[(Long, List[Long])]()

  for (line <- source.getLines()) {
    val s = line.split(": ").toList
    val res: Long = s(0).toLong
    val operands = s(1).split(" ").map(x=>x.toLong).toList

    inputs = inputs :+ (res, operands)
  }
  source.close()

  println(part1(inputs))
  println(part2(inputs))
