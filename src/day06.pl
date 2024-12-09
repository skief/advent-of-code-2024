use strict;
use warnings;

my @directions = ([-1, 0], [0, 1], [1, 0], [0, -1]);
my @map;

sub hasLoop {
    my $guardY = $_[0];
    my $guardX = $_[1];

    my $H = scalar @map;
    my $W = scalar @{ $map[0] };

    my $dir = 0;

    my @visited;
    for (my $y = 0; $y < $H; $y++){
        for (my $x = 0; $x < $W; $x++){
            for (my $i = 0; $i < 4; $i++){
                $visited[$y][$x][$i] = 0;
            }
        }
    }

    while (0 <= $guardY and $guardY < $H and 0 <= $guardX and $guardX < $W) {
        if ($visited[$guardY][$guardX][$dir] == 1){
            return 1;
        }

        $visited[$guardY][$guardX][$dir] = 1;

        my $newY = $guardY + $directions[$dir][0];
        my $newX = $guardX + $directions[$dir][1];

        if (0 <= $newY and $newY < $H and 0 <= $newX and $newX < $W){
            if ($map[$newY][$newX] == 0) {
                $guardY = $newY;
                $guardX = $newX;
            }
            else {
                $dir = ($dir + 1) % 4;
            }
        } else {
            last;
        }
    }

    return 0;
}

sub part1 {
    my $guardY = $_[0];
    my $guardX = $_[1];

    my $H = scalar @map;
    my $W = scalar @{ $map[0] };

    my $dir = 0;

    my @visited;
    for (my $y = 0; $y < $H; $y++){
        for (my $x = 0; $x < $W; $x++){
            $visited[$y][$x] = 0;
        }
    }

    while (0 <= $guardY and $guardY < $H and 0 <= $guardX and $guardX < $W) {
        $visited[$guardY][$guardX] = 1;

        my $newY = $guardY + $directions[$dir][0];
        my $newX = $guardX + $directions[$dir][1];

        if (0 <= $newY and $newY < $H and 0 <= $newX and $newX < $W){
            if ($map[$newY][$newX] == 0) {
                $guardY = $newY;
                $guardX = $newX;
            }
            else {
                $dir = ($dir + 1) % 4;
            }
        } else {
            last;
        }
    }

    my $sum = 0;
    for (my $y = 0; $y < $H; $y++){
        for (my $x = 0; $x < $W; $x++){
            $sum = $sum + $visited[$y][$x];
        }
    }
    return $sum;
}

sub part2 {
    my $guardY = $_[0];
    my $guardX = $_[1];

    my $startY = $_[0];
    my $startX = $_[1];

    my $H = scalar @map;
    my $W = scalar @{ $map[0] };

    my $dir = 0;

    my @visited;
    for (my $y = 0; $y < $H; $y++){
        for (my $x = 0; $x < $W; $x++){
            $visited[$y][$x] = 0;
        }
    }

    while (0 <= $guardY and $guardY < $H and 0 <= $guardX and $guardX < $W) {
        $visited[$guardY][$guardX] = 1;

        my $newY = $guardY + $directions[$dir][0];
        my $newX = $guardX + $directions[$dir][1];

        if (0 <= $newY and $newY < $H and 0 <= $newX and $newX < $W){
            if ($map[$newY][$newX] == 0) {
                $guardY = $newY;
                $guardX = $newX;
            }
            else {
                $dir = ($dir + 1) % 4;
            }
        } else {
            last;
        }
    }
    $visited[$startY][$startX] = 0;

    my $count = 0;

    for (my $y = 0; $y < $H; $y++){
        for (my $x = 0; $x < $W; $x++){
            if ($visited[$y][$x] == 1){
                $map[$y][$x] = 1;
                if (hasLoop($startY, $startX) == 1){
                    $count++;
                }

                $map[$y][$x] = 0;
            }
        }
    }
    return $count;
}

open my $if, "<:encoding(UTF-8)", "inputs/day06";

my $y = 0;
my $guardX = -1;
my $guardY = -1;

while (my $line = <$if>){
    $line =~ s/[\x0A\x0D]//g;

    foreach my $x (0..length($line) - 1){
        my $char = substr($line, $x, 1);

        if ($char eq "."){
            $map[$y][$x] = 0;
        } elsif ($char eq "^"){
            $map[$y][$x] = 0;
            $guardX = $x;
            $guardY = $y;
        } elsif ($char eq "#"){
            $map[$y][$x] = 1;
        }
    }

    $y++;
}

print part1($guardY, $guardX), "\n";
print part2($guardY, $guardX), "\n";
