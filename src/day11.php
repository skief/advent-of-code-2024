<?php

$blinkCache = array(0, 1);
function blink($stone, $t){
    global $blinkCache;
    $key = $stone . ":" . $t;

    if (array_key_exists($key, $blinkCache)){
        return $blinkCache[$key];
    }

    if ($t == 0) {
        $count = 1;
    } else if ($stone == 0){
        $count = blink(1, $t - 1);
    } else if (strlen($stone) % 2 == 0){
        $stone_str = strval($stone);
        $left = (int) substr($stone_str, 0, strlen($stone_str) / 2);
        $right = (int) substr($stone_str, strlen($stone_str) / 2);

        $count = blink($left, $t - 1) + blink($right, $t - 1);
    } else {
        $count = blink($stone * 2024, $t - 1);
    }

    $blinkCache[$key] = $count;
    return $count;
}

function part1($stones){
    $count = 0;
    for ($i = 0; $i < count($stones); $i++){
        $count += blink($stones[$i], 25);
    }

    return $count;
}

function part2($stones){
    $count = 0;
    for ($i = 0; $i < count($stones); $i++){
        $count += blink($stones[$i], 75);
    }

    return $count;
}

$handle = fopen("../inputs/day11", "r");
$line = fgets($handle);
fclose($handle);

$stones = preg_split('/\s+/', $line);

echo part1($stones) . PHP_EOL;
echo part2($stones) . PHP_EOL;
