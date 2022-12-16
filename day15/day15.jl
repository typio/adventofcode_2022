using Match

filepath = ARGS[1]

file_contents = read(filepath, String)
lines = split(file_contents, "\n")

data = [collect(transpose(reshape([parse(Int, m.match) + 1 for m in eachmatch(r"-?\d+", line)], (2, 2)))) for line in lines]

minx = typemax(Int)
maxx = typemin(Int)
for line in data
    global minx = min(line[1, 1], line[2, 1]) < minx ? min(line[1, 1], line[2, 1]) : minx
    global maxx = max(line[1, 1], line[2, 1]) > maxx ? max(line[1, 1], line[2, 1]) : maxx

end
println("$minx, $maxx")

mdist(x1, y1, x2, y2) = abs(x2 - x1) + abs(y2 - y1)

# row = []
# for i in (minx-1000000):(maxx+1000000)
#     c = '.'
#     curr = [i, 2000000 + 1]
#     for (sx, bx, sy, by) in data
#         if curr == [sx, sy]
#             c = 'S'
#             break
#         elseif curr == [bx, by]
#             c = 'B'
#             break
#         elseif mdist(curr[1], curr[2], sx, sy) <= mdist(sx, sy, bx, by)
#             c = '#'
#             break
#         elseif curr[1] >= 0 && curr[2] <= 20
#             println("Found $curr")
#         end
#     end
#     push!(row, c)
#     if (i % 10000 == 0)
#         print("$i\r")
#         flush(stdout)
#     end
# end
# # map(e -> print(e), row)
# println()
# println(count(i -> (i == '#'), row))

function checkpoint(point, data)
    # println(point)
    issolution = false
    for (sx, bx, sy, by) in data
        if mdist(point[1], point[2], sx, sy) <= mdist(sx, sy, bx, by)
            return false
        else
            issolution = true
        end
    end
    return issolution
end

# loop over permimiters?? idk, 4e6 * 4e6 is too much
for (sx, bx, sy, by) in data#[3:7]
    # print("$sx $sy, $bx $by")
    lim = 4000001 # 21
    pdist = mdist(sx, sy, bx, by)
    curr = [sx - pdist - 1, sy]
    # go ↗
    while curr[1] < sx
        curr += [1, 1]
        if curr[1] >= 1 && curr[1] <= lim && curr[2] >= 1 && curr[2] <= lim && checkpoint(curr, data)
            println("Found $curr, $((curr[1]-1)*4000000 +( curr[2]-1))")
        end
    end
    # go ↘
    while curr[2] > sy
        curr += [1, -1]
        if curr[1] >= 1 && curr[1] <= lim && curr[2] >= 1 && curr[2] <= lim && checkpoint(curr, data)
            println("Found $curr, $((curr[1]-1)*4000000 +( curr[2]-1))")
        end
    end
    # go ↙
    while curr[1] > sx
        curr += [-1, -1]
        if curr[1] >= 1 && curr[1] <= lim && curr[2] >= 1 && curr[2] <= lim && checkpoint(curr, data)
            println("Found $curr, $((curr[1]-1)*4000000 +( curr[2]-1))")
        end
    end
    # go ↖
    while curr[2] < sy
        curr += [-1, 1]
        if curr[1] >= 1 && curr[1] <= lim && curr[2] >= 1 && curr[2] <= lim && checkpoint(curr, data)
            println("Found $curr, $((curr[1]-1)*4000000 +( curr[2]-1))")
        end
    end
end

# LETS GOOOOOOOOOOOOOOOOOOO!!!!!!!!!!