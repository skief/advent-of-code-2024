#!/bin/sh
# Calling: ./day03.sh <path_to_input>

# Part 1:
grep -Eo 'mul\(([0-9]{1,3}),([0-9]{1,3})\)' $1 | sed -nE 's/mul\(([0-9]{1,3}),([0-9]{1,3})\)/\1*\2/p' | paste -sd "+" - | bc

# Part 2:
paste -s inputs/day03 | sed -E "s/don't\(\)/\ndon't\(\)/g" | sed -E "s/do\(\)/\ndo\(\)/g" | grep -v "^don't\(\)" | grep -Eo 'mul\(([0-9]{1,3}),([0-9]{1,3})\)' | sed -nE 's/mul\(([0-9]{1,3}),([0-9]{1,3})\)/\1*\2/p' | paste -sd "+" - | bc
