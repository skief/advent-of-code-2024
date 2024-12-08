#!/usr/bin/bash

inRange () {
  if (($1 >= 0 && $1 < H && $2 >= 0 && $2 < W)); then
    return 1
  else
    return 0
  fi
}

readarray -t input < ../inputs/day04

H=${#input[@]}
W=$((${#input[0]} - 1))

declare -a dY=(0 1 1 1 0 -1 -1 -1)
declare -a dX=(1 1 0 -1 -1 -1 0 1)

# Part 1
count=0
word="XMAS"
word_len=${#word}
for ((y = 0; y < H; y++));
do
  for ((x = 0; x < W; x++));
  do
    if [ "${input[y]:x:1}" != "${word:0:1}" ]; then
      continue
    fi

    for ((dir=0; dir < 8; dir++));
    do
      x2=$((x + (word_len-1)*dX[dir]))
      y2=$((y + (word_len-1)*dY[dir]))

      inRange "$y2" "$x2"
      if [ $? = 1 ]; then
        match=1
        testY=$y
        testX=$x
        for ((j = 0; j < word_len; j++));
        do
          if [ "${input[testY]:testX:1}" != "${word:j:1}" ]; then
            match=0
            break
          fi
          testY=$((testY + dY[dir]))
          testX=$((testX + dX[dir]))
        done

        if [ $match = 1 ]; then
          count=$((count + 1))
        fi
      fi
    done
  done
done

echo $count

# Part 2
count=0
word="MAS"
for ((y = 0; y < H; y++));
do
  for ((x = 0; x < W; x++));
  do
    if [ "${input[y]:x:1}" != "${word:1:1}" ]; then
      continue
    fi

    matches=0
    for ((dir=1; dir < 8; dir+=2));
    do
      y0=$((y - dY[dir]))
      x0=$((x - dX[dir]))
      inRange "$y0" "$x0"
      if [ $? != 1 ]; then
        continue
      fi

      y1=$((y + dY[dir]))
      x1=$((x + dX[dir]))
      inRange "$y1" "$x1"
      if [ $? != 1 ]; then
        continue
      fi

      if [ "${input[y0]:x0:1}" == "${word:0:1}" ] && [ "${input[y1]:x1:1}" == "${word:2:1}" ]; then
        matches=$((matches + 1))
      fi
    done
    if [ $matches == 2 ]; then
      count=$((count + 1))
    fi
  done
done

echo $count
