filepath = ARGS[1]

file_contents = read(filepath, String)
lines = split(file_contents, "\n")
substrings = map(x -> split(x, " -> "), lines)

rockwalls = map(substrings ->
        map(substr ->
                [(parse(Int, x) + 1) for x in split(substr, ",")], substrings), # +1 to convert to 1-indexing
    substrings)

ranges = Dict{String,Int}("xmin" => typemax(Int), "xmax" => typemin(Int), "ymin" => 1, "ymax" => typemin(Int)) # literally cant go wrong

for wall in rockwalls, point in wall # omfggggg 💦💦💦
    x, y = point
    ranges["xmin"] = min(x, ranges["xmin"])
    ranges["xmax"] = max(x, ranges["xmax"])
    ranges["ymax"] = max(y, ranges["ymax"])
end

grid = fill('.', (ranges["ymax"], ranges["xmax"]))

function buildwalls()
    for wall in rockwalls
        for segment in zip(wall, wall[2:end])
            x1, x2, y1, y2 = segment[1][1], segment[2][1], segment[1][2], segment[2][2]
            if x1 != x2
                for i in min(x1, x2):max(x1, x2)
                    setindex!(grid, '#', y1, i)
                end
            elseif y1 != y2
                for i in min(y1, y2):max(y1, y2)
                    setindex!(grid, '#', i, x1)
                end
            end
        end
    end
end

function print_cave()
    sleep(0.1)
    run(`clear`)
    for i in ranges["ymin"]:ranges["ymax"]
        for j in ranges["xmin"]:ranges["xmax"]
            print(grid[i, j])
        end
        println()
    end
end

buildwalls()

sandorigin = [1, 501]
setindex!(grid, '+', sandorigin[1], sandorigin[2])

# print_cave()
function dropsand()
    sandgraincount = 0
    while true
        if grid[sandorigin[1], sandorigin[2]] == 'O'
            println("Part 2: $sandgraincount")
            @goto done
        end

        sandpos = sandorigin
        try
            while true


                if grid[sandpos[1]+1, sandpos[2]] ∉ ['#', 'O']
                    sandpos += [1, 0]
                elseif grid[sandpos[1]+1, sandpos[2]-1] ∉ ['#', 'O']
                    sandpos += [1, -1]
                elseif grid[sandpos[1]+1, sandpos[2]+1] ∉ ['#', 'O']
                    sandpos += [1, 1]
                else
                    break
                end
            end
        catch
            println("Part 1: $sandgraincount")
            @goto done
        end

        if sandpos[1] < size(grid)[1] && sandpos[2] < size(grid)[2]
            setindex!(grid, 'O', sandpos[1], sandpos[2])
            sandgraincount += 1
            # print_cave() # stdout too slow for full input
        else
            println("done")
            return
        end
    end
    @label done
end

dropsand() # part 1


ranges["ymax"] += 2
ranges["xmin"] = 1
ranges["xmax"] = 1000
grid = fill('.', (ranges["ymax"], ranges["xmax"]))

for i in 1:size(grid)[2]
    setindex!(grid, '#', ranges["ymax"], i)
end

buildwalls()
# print_cave()
dropsand() # part 2