def read_input
  rules = []
  productions = []

  read_req = true
  File.readlines("inputs/day05").each do |line|
    line = line.strip
    if line.length == 0
      read_req = false
      next
    end

    if read_req
      req, to = line.split("|").map(&:to_i)

      rules.push([req, to])
    else
      productions.push(line.split(",").map(&:to_i))
    end
  end

  [rules, productions]
end

def is_ordered(rules, production)
  rules.each do |a, b|
    a_index = production.index(a)
    b_index = production.index(b)

    if a_index != nil and b_index != nil and a_index > b_index
      return false
    end
  end

  true
end

def fix_order(rules, production)
  fixed = true

  rules.each do |a, b|
    a_index = production.index(a)
    b_index = production.index(b)

    if a_index != nil and b_index != nil and a_index > b_index
      production[a_index], production[b_index] = production[b_index], production[a_index]
      fixed = false
    end
  end

  unless fixed
    fix_order(rules, production)
  end
end


def part1(rules, productions)
  sum = 0
  productions.each do |production|
    if is_ordered(rules, production)
      sum += production[production.size / 2]
    end
  end

  sum
end

def part2(rules, productions)
  sum = 0
  productions.each do |production|
    if is_ordered(rules, production)
      next
    end

    fix_order(rules, production)
    sum += production[production.size / 2]
  end

  sum
end

rules, productions = read_input

puts part1(rules, productions)
puts part2(rules, productions)
