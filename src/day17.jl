function run(registers, instructions)
    registers = copy(registers)
    pc = 0
    outputs = Int64[]

    while pc < length(instructions)
        op = instructions[pc + 1]
        operand = instructions[pc + 2]

        combo = operand
        if operand >= 4
            combo = registers[operand - 3]
        end

        if op == 0
            registers[1] >>= combo
        elseif op == 1
            registers[2] = registers[2] ⊻ operand
        elseif op == 2
            registers[2] = mod(combo, 8)
        elseif op == 3 && registers[1] != 0
            pc = operand
            continue
        elseif op == 4
            registers[2] = registers[2] ⊻ registers[3]
        elseif op == 5
            push!(outputs, mod(combo, 8))
        elseif op == 6
            registers[2] = registers[1] >> combo
        elseif op == 7
            registers[3] = registers[1] >> combo
        end

        pc += 2
    end

    return outputs
end

function part1(registers, instructions)
    return join(run(registers, instructions), ",")
end

function part2(registers, instructions)
    registers = copy(registers)

    a = 0
    for n in 1:length(instructions) - 1
        subInstr = instructions[end - n: end]

        a *= 8
        while true
            registers[1] = a

            outputs = run(registers, instructions) 
            if outputs == subInstr
                break
            end
            a += 1
        end
    end
    return a
end

registers = zeros(Int64, 3)
lines = readlines("inputs/day17")
for line in lines
    if length(line) == 0
        break
    end

    split = collect(eachsplit(line, ":"))
    register = collect(eachsplit(split[1], " "))[end]
    val = split[end]
    registers[register[1] - 'A' + 1] =  parse(Int64, val)
end

instructions = collect(map(x -> parse(Int64, x), eachsplit(lines[end][10:end], ",")))

println(part1(registers, instructions))
println(part2(registers, instructions))
