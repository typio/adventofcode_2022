using Printf

filepath = ARGS[1]

jet_sequence = read(filepath, String)
jet_seq_l = length(jet_sequence)

grid = fill('.', (4, 7))

# build floor 
for i in 1:7
    setindex!(grid, '#', 1, i)
end


function print_chamber()
    sleep(0.01)
    run(`clear`)
    for i in reverse(1:size(grid)[1])
        for j in 1:size(grid)[2]
            print(grid[i, j])
        end
        println()
    end
end

# print_chamber()

shapes = [
    [
        '.' '.' '@' '@' '@' '@' '.'
    ],
    [
        '.' '.' '.' '@' '.' '.' '.'
        '.' '.' '@' '@' '@' '.' '.'
        '.' '.' '.' '@' '.' '.' '.'
    ],
    [
        '.' '.' '@' '@' '@' '.' '.'
        '.' '.' '.' '.' '@' '.' '.'
        '.' '.' '.' '.' '@' '.' '.'
    ],
    [
        '.' '.' '@' '.' '.' '.' '.'
        '.' '.' '@' '.' '.' '.' '.'
        '.' '.' '@' '.' '.' '.' '.'
        '.' '.' '@' '.' '.' '.' '.'
    ],
    [
        '.' '.' '@' '@' '.' '.' '.'
        '.' '.' '@' '@' '.' '.' '.'
    ],
]

emptyspace = ['.' '.' '.' '.' '.' '.' '.'
    '.' '.' '.' '.' '.' '.' '.'
    '.' '.' '.' '.' '.' '.' '.']

function playtetris()
    stoppedrocks = 0
    jetindex = 0
    rockwindowh = 4
    highestrock = 1
    removedamt = 0
    while stoppedrocks < 2022
        # create rock
        newrock = shapes[(stoppedrocks)%size(shapes)[1]+1]
        grid = grid[1:highestrock-removedamt, :]
        global grid = vcat(grid, emptyspace)
        global grid = vcat(grid, newrock)
        rocktop = size(grid)[1]
        # print_chamber()

        # display(view(grid, (rocktop-3):rocktop, :))
        # display(grid)

        # lower rock
        rockisfalling = true
        falling_turn = false
        while rockisfalling
            blocked_b, blocked_l, blocked_r = false, false, false

            jetdir = jet_sequence[(jetindex%jet_seq_l)+1] == '<' ? -1 : 1
            # scan to check if a unit is blocked
            # for coord in eachindex(view(grid, (rocktop-3):rocktop, :))
            for y in rocktop-rockwindowh:rocktop, x in 1:7
                # println("$x $y")
                if grid[y, x] == '@'
                    if falling_turn && grid[y-1, x] == '#'
                        blocked_b = true
                        rockisfalling = false
                    elseif !falling_turn && jetdir == 1 && (x == 7 || grid[y, x+1] == '#')
                        blocked_r = true
                    elseif !falling_turn && jetdir == -1 && (x == 1 || grid[y, x-1] == '#')
                        blocked_l = true
                    end
                end
            end
            # move all units in stone
            # for coord in eachindex(view(grid, (rocktop-rockwindowh):rocktop, :))
            movetocords = []
            for y in rocktop-rockwindowh:rocktop, x in 1:7
                if grid[y, x] == '@'
                    if falling_turn && !blocked_b # move down
                        # grid[y-1, x] = '@'
                        push!(movetocords, CartesianIndex(y - 1, x))
                        grid[y, x] = '.'
                    elseif blocked_b # solidify
                        grid[y, x] = '#'
                        highestrock = max(highestrock, y + removedamt)
                    elseif !falling_turn && !blocked_l && jetdir == -1
                        push!(movetocords, CartesianIndex(y, x - 1))
                        # grid[y, x-1] = '@'
                        grid[y, x] = '.'
                    elseif !falling_turn && !blocked_r && jetdir == 1
                        push!(movetocords, CartesianIndex(y, x + 1))
                        grid[y, x] = '.'
                        # grid[y, x+1] = '@'
                    end
                end
            end
            for coord in movetocords
                grid[coord] = '@'
            end
            if falling_turn && !blocked_b
                rocktop = rocktop - 1 > rockwindowh ? rocktop - 1 : rocktop
            end
            if !falling_turn
                jetindex += 1
            end
            falling_turn = !falling_turn


            # print_chamber()
        end


        # print_chamber()

        if size(grid)[1] > 100
            global grid = grid[50:size(grid)[1], :]
            removedamt += 49
            # println("clear!")
        end

        stoppedrocks += 1
        # if stoppedrocks % 10000 == 0
        #     @printf "%.12f\r" stoppedrocks / 1000000000000
        # end
    end
    println(highestrock - 1)

end


playtetris()

# think I theoretically know how to do part 2 (find repeating patterns) but I dont feel like it