include("puzzle_core.jl")

struct Entity 
    x:: Int
    y:: Int
end

function printsum(str, a)
    # summary generates a summary of an object
    println(str, summary(a), ": ", repr(a))
end


function init_board_and_entities()
    lines = open("input.txt") do file
        readlines(file)
    end
    
    entities = Array{Entity}(undef, length(lines))
    entities_in_closed_area = trues(length(lines))

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

    for i in eachindex(entities)
        entity = entities[i]
        board[entity.x, entity.y] = i
    end

    return board, entities_in_closed_area
end


board, entities = init_board_and_entities()
board = expands_entities_area(board)
entities = get_entities(board, entities)
max_area = get_max_area(board, entities)
@show max_area