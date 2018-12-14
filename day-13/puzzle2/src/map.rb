

class Map
    def initialize(strings)
        @circuit = []
        strings.each do |s|
            @circuit.push(s.split(""))
        end

        for i in 0..height-1
            for j in 0..width-1
                c = @circuit[i][j]
                if c == '^' || c == 'v'
                    @circuit[i][j] = '|'
                elsif c == '<' || c == '>'
                    @circuit[i][j] = '-'
                end
            end
        end
    end

    def circuit
        return @circuit
    end

    def cars
        return @cars
    end

    def height
        return @circuit.length
    end

    def width
        return @circuit[0].length
    end

    def cell(x, y)
        return @circuit[y][x]
    end
end