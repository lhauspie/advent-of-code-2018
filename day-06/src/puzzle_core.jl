
struct Entity 
    x:: Int
    y:: Int
end



function expands_entities_area(board)
    result = board;
    while !is_complete(result)
        result = next_step(result)
    end
    return result
end

function next_step(board)
    if length(board) == 0
        return board;
    end

    result = deepcopy(board)

    x_size = size(board)[1];
    y_size = size(board)[2];
    for x in 1:x_size
        for y in 1:y_size
            cell = board[x, y]
            if isOccupied(cell)
                continue
            end

            # left
            if x - 1 >= 1
                cell = get_new_cell_value(cell, board[x-1, y])
            end
            
            # right
            if x + 1 <= x_size
                cell = get_new_cell_value(cell, board[x+1, y])
            end

            # up
            if y - 1 >= 1
                cell = get_new_cell_value(cell, board[x, y-1])
            end
            
            # down
            if y + 1 <= y_size
                cell = get_new_cell_value(cell, board[x, y+1])
            end
            
            result[x, y] = cell; 
        end
    end
    return result
end

# isOccupied : the cell is containing something else than 0
# -1 means unoccupied but can't be occupied
# 0 means unoccupied and can be taken by neighbour entities
# 1+ means occupied by an entity
function isOccupied(cell)
    return cell != 0;
end

function get_new_cell_value(cell, neighbour)
    if cell < 0 || neighbour <= 0
        return cell
    elseif cell > 0 && cell != neighbour
        return -1
    else
        return neighbour
    end
end 

function is_complete(board)
    for index in eachindex(board)
        if board[index] == 0
            return false
        end
    end
    return true
end


function get_entities(board, entities)
    if length(board) == 0 || length(entities) == 0
        return entities;
    end;

    temp_entities = deepcopy(entities)
    x_size = size(board)[1];
    y_size = size(board)[2];
    for x in 1:x_size
        # println("board[x, 1] : ", board[x, 1])
        # println("board[x, y_size] : ", board[x, y_size])
        set_to(temp_entities, board[x, 1], false)
        set_to(temp_entities, board[x, y_size], false)
    end
    for y in 1:y_size
        # println("board[1, y] : ", board[1, y])
        # println("board[x_size, y] : ", board[x_size, y])
        set_to(temp_entities, board[1, y], false)
        set_to(temp_entities, board[x_size, y], false)
    end
    return temp_entities
end;

function set_to(entites, index, val)
    if index >0 && index <= length(entites)
        entites[index] = val
    end;
end

function get_max_area(board, entities)
    max_area = 0
    for i in eachindex(entities)
        if entities[i] == true
            area = count_area(board, i)
            if area > max_area
                max_area = area
            end
        end
    end
    return max_area
end

function count_area(board, entity)
    area = 0
    for i in eachindex(board)
        if board[i] == entity
            area = area + 1;
        end
    end

    return area
end


function mark_closer_area(board, entities, distance) 
    x_size = size(board)[1]
    y_size = size(board)[2]
    for x in 1:x_size
        for y in 1:y_size
            sum = 0
            for entity in entities
                sum = sum + abs(x - entity.x) + abs(y - entity.y)
            end
            if sum <= distance
                board[x, y] = 1;
            end
        end
    end
    return board
end