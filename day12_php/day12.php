<?php

$data = explode("\n", file_get_contents($argv[1]));
$data = array_map('str_split', $data);
$map = array();
$start_pos = [];
$a_pos = [];
$end_pos = [];
for ($i = 0; $i < count($data); $i++) {
    $map[] = [];
    for ($j = 0; $j < count($data[$i]); $j++) {
        $c = $data[$i][$j];
        if ($c == "a") {
            $a_pos[] = [$i, $j];
        }
        if ($c == "S") {
            $start_pos = [$i, $j];
            $map[$i][] = 0;
        } else if ($c == "E") {
            $end_pos = [$i, $j];
            $map[$i][] = 25;
        } else {
            $map[$i][] = ord($c) - ord("a");
        }
    }
}

function bfs($map, $start_pos, $end_pos)
{
    $queue = new SplQueue();
    $queue->enqueue($start_pos);

    $distanceMap = $map;

    for ($i = 0; $i < count($distanceMap); $i++) {
        for ($j = 0; $j < count($distanceMap[$i]); $j++) {
            $distanceMap[$i][$j] = 999;
        }
    }

    $distanceMap[$start_pos[0]][$start_pos[1]] = 0;

    while (!$queue->isEmpty()) {
        $coord = $queue->dequeue();
        $row = $coord[0];
        $col = $coord[1];

        if ($coord == $end_pos) {
            // print("found!\n");
            // for ($i = 0; $i < count($distanceMap); $i++) {
            //     for ($j = 0; $j < count($distanceMap[$i]); $j++) {
            //         printf("%03s ", $distanceMap[$i][$j]);
            //     }
            //     print("\n");
            // }
            return $distanceMap[$row][$col];
        }

        $directions = [[1, 0], [0, 1], [-1, 0], [0, -1]];

        foreach ($directions as $dir) {
            $i = $dir[0];
            $j = $dir[1];
            if (
                $row + $i < 0 ||
                $row + $i >= count($map) ||
                $col + $j < 0 ||
                $col + $j >= count($map[0])
            ) {
                continue;
            }

            if ($map[$row + $i][$col + $j] - 1 <= $map[$row][$col]) {
                $n_dist = $distanceMap[$row][$col] + 1;
                if ($n_dist < $distanceMap[$row + $i][$col + $j]) {
                    $queue->enqueue([$row + $i, $col + $j]);
                    $distanceMap[$row + $i][$col + $j] = $n_dist;
                }
            }
        }
    }
    return null;
}

$distance = bfs($map, $start_pos, $end_pos);
printf("Part 1: %d\n", $distance);

$distances = [];
foreach ($a_pos as $pos) {
    $res = bfs($map, $pos, $end_pos);
    if ($res !== null) {
        $distances[] = bfs($map, $pos, $end_pos);
    }
}
printf("Part 2: %d\n", min($distances));

// wow this took away any confidence I had in my coding or brain