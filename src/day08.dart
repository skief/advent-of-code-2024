import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:collection';


bool inRange(Point p, int h, int w){
    return 0 <= p.x && p.x < w && 0 <= p.y && p.y < h;
}

int part1(final Map<String, List<Point>> antennas, int h, int w) {
    var antinodes = Set<Point>();

    antennas.forEach((key, nodes) {
        for (final p1 in nodes) {
            for (final p2 in nodes) {
                var diff = p1 - p2;
                var antinode = p1 + diff;

                if (inRange(antinode, h, w) && antinode != p2) {
                    antinodes.add(antinode);
                }
            };
        };
    });

    return antinodes.length;
}

int part2(final Map<String, List<Point>> antennas, int h, int w) {
    var antinodes = Set<Point>();

    antennas.forEach((key, nodes) {
        for (final p1 in nodes) {
            for (final p2 in nodes) {
                if (p1 == p2){
                    continue;
                }

                var diff = p1 - p2;
                var antinode = p1;
                while (inRange(antinode, h, w)) {
                    antinodes.add(antinode);
                    antinode = antinode + diff;
                }
            };
        };
    });

    return antinodes.length;
}

void main() async {
    Map<String, List<Point>> antennas = HashMap();

    var lines = new File('../inputs/day08')
                    .openRead()
                    .map(utf8.decode)
                    .transform(new LineSplitter());

    var y = 0;
    var w;

    await for (var line in lines){
        var x = 0;
        for (var c in line.split('')){
            if (c != '.'){
                var point = Point(x, y);
                if (!antennas.containsKey(c)){
                    antennas.addAll({c: <Point>[point]});
                } else {
                    var points = antennas[c];
                    if (points != null){
                        points.add(point);

                        antennas.update(c, (v) => points);
                    }
                }
            }
            x++;
        }
        w = x;
        y++;
    }

    var h = y;

    print(part1(antennas, h, w));
    print(part2(antennas, h, w));
}