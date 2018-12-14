

class Direction

    def initialize (dx, dy)
        @dx = dx
        @dy = dy
    end

    def dx
        return @dx
    end

    def dy
        return @dy
    end
end

module Directions
    UP = Direction.new(0, -1)
    DOWN = Direction.new(0, 1)
end

class Car
    def initialize (position, symbol)
        @symbol = symbol
        @position = position
        if symbol == 'v'
            @direction = Directions::DOWN
        elsif symbol == '^'
            @direction = Directions::UP
        end
    end

    def direction
        return @direction
    end
end
