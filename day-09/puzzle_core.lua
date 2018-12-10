local M = {} --module

    M.Node = {value = 0, next, prev} --class
        function M.Node:new (value)
            o = {value=value}
            setmetatable(o, self)
            self.__index = self
            return o
        end

        function M.Node:show (title)
            print(title or "", self.value, self.prev, self.next)
        end
    --class M.Node 

    M.CircleList = {current = nil, size = 0} --class
        function M.CircleList:new(...)
            o = {current = nil, size = 0}
            setmetatable(o, self)
            self.__index = self
            return o
        end

        function M.CircleList:add(node)
            if self.size == 0 then
                self.current = node
                self.current.next = node
                self.current.prev = node
            else
                node.prev = self.current
                node.next = self.current.next
                node.next.prev = node
                self.current.next = node
                self.current = node
            end
            self.size = self.size + 1
        end

        function M.CircleList:remove()
            if self.current ~= nil then
                local current = self.current
                
                self.current.prev.next, self.current.next.prev = self.current.next, self.current.prev 
                self.current = self.current.next

                self.size = self.size - 1
                current.next = nil
                current.prev = nil
                return current
            else
                return M.Node:new(0)
            end
        end

        function M.CircleList:moveForward(n)
            if self.current == nil then
                return
            end
            for i=1,n do
                self.current = self.current.next
            end
        end

        function M.CircleList:moveBackward(n)
            if self.current ~= nil then
                for i=1,n do
                    self.current = self.current.prev
                end
            end
        end
    --class M.CircleList

    M.Player = {id, score = 0} --class
        function M.Player:new(id)
            o = {id = id, score = 0}
            setmetatable(o, self)
            self.__index = self
            return o
        end

        function M.Player:play(circle, marble)
            if marble % 23 == 0 then
                circle:moveBackward(7)
                removed = circle:remove()
                self.score = self.score + marble
                self.score = self.score + removed.value
            else
                circle:moveForward(1)
                circle:add(M.Node:new(marble))
            end
        end
    --class M.Player


    function M.ResolvePuzzle(nbPlayers, nbMarbles)
        players = {}
        for i=1,nbPlayers do
            players[i] = M.Player:new(i)
        end

        circle = M.CircleList:new()
        circle:add(M.Node:new(0))

        current_marble = 1
        while current_marble <= nbMarbles do
            for i=1,nbPlayers do
                if current_marble <= nbMarbles then
                    players[i]:play(circle, current_marble)
                    current_marble = current_marble + 1
                end
            end
        end

        max_score = 0
        for i, player in ipairs(players) do
            if max_score < player.score then
                max_score = player.score
            end
        end
        return max_score
    end
return M
--module puzzle_core
