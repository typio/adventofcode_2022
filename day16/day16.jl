using OrderedCollections, Random

filepath = ARGS[1]

file_contents = read(filepath, String)
lines = split(file_contents, "\n")

g = OrderedDict()

for line in lines
    g[match(r"[A-Z]{2}", line).match] = [
        parse(Int, match(r"\d+", line).match),
        [string(m.match) for m in eachmatch(r"[A-Z]{2}(?=,|$)", line)]
    ]
end

function DFS(g, s)
    stack = [s]
    visited = OrderedSet()
    while !isempty(stack)
        v = pop!(stack)
        push!(visited, v)
        for neighbor in g[v][2]
            if neighbor ∉ visited
                push!(stack, neighbor)
            end
        end
    end
    return visited
end

function DFSCost(g, s, t)
    if (s == t)
        return 0
    end
    stack = [(s, 0)]
    visited = OrderedSet()
    while !isempty(stack)
        v, c = pop!(stack)
        push!(visited, v)
        for neighbor in g[v][2]
            if neighbor ∉ visited
                if neighbor == t
                    return c + 1
                end
                push!(stack, (neighbor, c + 1))
            end
        end
    end
    return -1
end

positive_v = [] # build list of nodes that matter, have pressure or are start
for (v, d) in g
    if d[1] != 0 || v == "AA"
        push!(positive_v, v)
    end
end

g_short_list = Dict()
for (v, d) in g
    if d[1] != 0 || v == "AA"
        g_short_list[v] = []
        for (v2, d2) in g
            if g[v2][2] != 0 && v != v2
                push!(g_short_list[v], [v2, DFSCost(g, v, v2)])
            end
        end
    end
end
# display(g_short_list)

# g_short_size = size(positive_v)[1]
# g_short_m = zeros((g_short_size, g_short_size))

# for (i, s) in enumerate(positive_v), (j, t) in enumerate(positive_v)
#     g_short_m[i, j] = DFSCost(g, s, t)
# end

# # display(g_short_m)

# function AllPathsBFS(g_m, s)
#     queue = [s]
#     visited = Set([s])
#     while !isempty(queue)
#         v = popfirst!(queue)
#         println(v)

#         for curr in positive_v
#             if g_m[findall(x->x==v, positive_v)[1], findall(x->x==curr, positive_v)[1]] >= 1 && !(curr in visited)
#                 push!(queue, curr)
#                 push!(visited, curr)
#             end
#         end
#     end

# end

# AllPathsBFS(g_short_m, "AA")

# println(DFS(g, "AA"))

# println(DFSCost(g, "AA", "FF"))

function GetPaths(g, s, length)
    paths = []
    stack = [s]
    path = [s]
    l = 0
    while !isempty(stack)
        v = pop!(stack)
        if l >= length
            push!(paths, path)
        elseif l < length
            for neighbor in g[v]
                l += neighbor[2]
                push!(stack, neighbor[1])
                push!(path, neighbor[1])
            end
            last = pop!(path)
            l -= g[last][2]
        end
    end
    return paths
end

println!(GetPaths(g, "AA", 5))