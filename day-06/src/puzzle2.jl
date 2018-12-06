include("puzzle_core.jl")

function printsum(str, a)
    # summary generates a summary of an object
    println(str, summary(a), ": ", repr(a))
end


function init_board_and_entities()
    lines = open("input.txt") do file
        readlines(file)
    end
    
    entities = Array{Entity}(undef, length(lines))

    max_x = 0;
    max_y = 0;
    for i in 1:length(lines)
        entity_coord = split(lines[i], ", ")
        entity_x = parse(Int, entity_coord[1])::Int
        entity_y = parse(Int, entity_coord[2])::Int
        entities[i] = Entity(entity_x, entity_y)

        if entity_x > max_x
            max_x = entity_x
        end
        if entity_y > max_y
            max_y = entity_y
        end
    end

    board = zeros(Int, max_x, max_y)

    return board, entities
end


board, entities = init_board_and_entities()
board = mark_closer_area(board, entities, 10000)
max_area = get_max_area(board, [true])
@show max_area
