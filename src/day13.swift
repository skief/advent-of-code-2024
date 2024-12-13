import Foundation

struct Pos2D {
    let x: Int
    let y: Int
}

struct Machine {
    let a: Pos2D
    let b: Pos2D
    let prize: Pos2D
}

extension String {
    func groups(for regexPattern: String) -> [[String]] {
    do {
        let text = self
        let regex = try NSRegularExpression(pattern: regexPattern)
        let matches = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return matches.map { match in
            return (0..<match.numberOfRanges).map {
                let rangeBounds = match.range(at: $0)
                guard let range = Range(rangeBounds, in: text) else {
                    return ""
                }
                return String(text[range])
            }
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}
}

func parsePos(line: String) -> Pos2D {
    let m = line.groups(for: #"X.(\d+), Y.(\d+)"#)[0]

    return Pos2D(x: Int(m[1])!, y: Int(m[2])!)
}

func solve(machines: [Machine], offset: Int) -> Int {
    var sum: Int = 0

    machines.forEach { machine in
        let denom = machine.a.x * machine.b.y - machine.a.y * machine.b.x
        var a = machine.b.y * (offset + machine.prize.x) - machine.b.x * (offset + machine.prize.y)
        var b = -machine.a.y * (offset + machine.prize.x) + machine.a.x * (offset + machine.prize.y)

        if (a % denom == 0 && b % denom == 0) {
            a = a / denom
            b = b / denom
            sum += 3 * a + b
        }
    }

    return sum
}

func part1(machines: [Machine]) -> Int {
    return solve(machines: machines, offset: 0)
}

func part2(machines: [Machine]) -> Int {
    return solve(machines: machines, offset: 10000000000000)
}


let file = URL(fileURLWithPath: "../inputs/day13")
let content = try String(contentsOf: file, encoding: .utf8)
let lines = content.split(whereSeparator: \.isNewline).map(String.init)

var machines: [Machine] = []
for i in stride(from: 0, to: lines.count, by: 3) {
    let a = parsePos(line: lines[i])
    let b = parsePos(line: lines[i + 1])
    let prize = parsePos(line: lines[i + 2])

    machines.append(Machine(a: a, b: b, prize: prize))
}

print(part1(machines: machines))
print(part2(machines: machines))
