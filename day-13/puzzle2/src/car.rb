

class Direction
    def initialize (x, y, symbol)
        @x = x
        @y = y
        @symbol = symbol
    end

    def x
        return @x
    end

    def y
        return @y
    end

    def symbol
        return @symbol
    end
end

module Directions
    UP = Direction.new(0, -1, '^')
    DOWN = Direction.new(0, 1, 'v')
    LEFT = Direction.new(-1, 0, '<')
    RIGHT = Direction.new(1, 0, '>')

    DIRECTION_BY_TURNING_LEFT = {
        Directions::UP => Directions::LEFT,
        Directions::LEFT => Directions::DOWN,
        Directions::DOWN => Directions::RIGHT,
        Directions::RIGHT => Directions::UP
    }
    
    DIRECTION_BY_TURNING_RIGHT = {
        Directions::UP => Directions::RIGHT,
        Directions::RIGHT => Directions::DOWN,
        Directions::DOWN => Directions::LEFT,
        Directions::LEFT => Directions::UP
    }
end

module Actions
    TURN_LEFT = "left"
    STRAIGHT = "straight"
    TURN_RIGHT = "right"

    NEXT_ACTION = {
        Actions::TURN_LEFT => Actions::STRAIGHT,
        Actions::STRAIGHT => Actions::TURN_RIGHT,
        Actions::TURN_RIGHT => Actions::TURN_LEFT
    }
end

class Car
    def initialize (id, x, y, symbol)
        @crashed = false
        @id = id
        @x = x
        @y = y
        @action_to_do_on_next_crossroads = Actions::TURN_LEFT
        if symbol == 'v'
            @direction = Directions::DOWN
        elsif symbol == '^'
            @direction = Directions::UP
        elsif symbol == '>'
            @direction = Directions::RIGHT
        elsif symbol == '<'
            @direction = Directions::LEFT
        end
    end

    def direction
        return @direction
    end

    def id
        return @id
    end

    def x
        return @x
    end

    def y
        return @y
    end

    def crashed
        return @crashed
    end

    def set_crashed(crashed)
        @crashed = crashed
    end

    def turn_left
        @direction = Directions::DIRECTION_BY_TURNING_LEFT[@direction]
        @symbol = @direction.symbol
    end

    def turn_right
        @direction = Directions::DIRECTION_BY_TURNING_RIGHT[@direction]
        @symbol = @direction.symbol
    end

    def straight
    end

    def turn
        if @action_to_do_on_next_crossroads == Actions::TURN_LEFT
            turn_left
        elsif @action_to_do_on_next_crossroads == Actions::STRAIGHT
            straight
        elsif @action_to_do_on_next_crossroads == Actions::TURN_RIGHT
            turn_right
        end
        @action_to_do_on_next_crossroads = Actions::NEXT_ACTION[@action_to_do_on_next_crossroads]
    end

    def move_forward
        @x = @x + direction.x
        @y = @y + direction.y
    end

    def to_string()
        return "Car #{id}#{direction.symbol}[#{x}, #{y}]"
    end
end
