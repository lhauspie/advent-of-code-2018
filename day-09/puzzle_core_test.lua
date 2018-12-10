luaunit = require('luaunit')
local puzzle_core = require("puzzle_core")


TestPuzzle = {} --class
    function TestPuzzle:testCreateNode()
        result = puzzle_core.Node:new(5)
        luaunit.assertEquals( type(result), 'table' )
        luaunit.assertEquals( result.value, 5 )
        luaunit.assertEquals( result.next, nil )
        luaunit.assertEquals( result.prev, nil )
    end

    function TestPuzzle:testCreateEmptyCircleList()
        result = puzzle_core.CircleList:new()
        luaunit.assertEquals( type(result), 'table' )
        luaunit.assertEquals( result.current, nil )
    end

    function TestPuzzle:testCreateCircleListWithOneElement()
        circle = puzzle_core.CircleList:new()
        circle:add(puzzle_core.Node:new(5))
        luaunit.assertEquals( circle.current.prev.value, 5 )
        luaunit.assertEquals( circle.current.value, 5 )
        luaunit.assertEquals( circle.current.next.value, 5 )
        luaunit.assertEquals( circle.size, 1 )
    end

    function TestPuzzle:testCreateCircleListWithTwoElements()
        circle = puzzle_core.CircleList:new()
        circle:add(puzzle_core.Node:new(5))
        circle:add(puzzle_core.Node:new(7))
        luaunit.assertEquals( circle.current.prev.value, 5 )
        luaunit.assertEquals( circle.current.value, 7 )
        luaunit.assertEquals( circle.current.next.value, 5 )
        luaunit.assertEquals( circle.size, 2 )
    end

    function TestPuzzle:getListOfFiveSevenTwelve()
        circle = puzzle_core.CircleList:new()
        circle:add(puzzle_core.Node:new(5))
        circle:add(puzzle_core.Node:new(7))
        circle:add(puzzle_core.Node:new(12))
        luaunit.assertEquals( circle.current.prev.value, 7 )
        luaunit.assertEquals( circle.current.value, 12 )
        luaunit.assertEquals( circle.current.next.value, 5 )
        luaunit.assertEquals( circle.size, 3 )
        return circle
    end

    function TestPuzzle:testCreateCircleListWithThreeElements()
        circle = TestPuzzle:getListOfFiveSevenTwelve()
    end

    function TestPuzzle:testMoveForwardOnEmptyCircle()
        circle = puzzle_core.CircleList:new()
        circle:moveForward(1)
        luaunit.assertEquals( circle.size, 0 )
    end

    function TestPuzzle:testMoveForwardOnce()
        circle = self:getListOfFiveSevenTwelve()
        circle:moveForward(1)
        luaunit.assertEquals( circle.current.prev.value, 12 )
        luaunit.assertEquals( circle.current.value, 5 )
        luaunit.assertEquals( circle.current.next.value, 7 )
        luaunit.assertEquals( circle.size, 3 )
    end

    function TestPuzzle:testMoveForwardTwice()
        circle = TestPuzzle:getListOfFiveSevenTwelve()
        circle:moveForward(2)
        luaunit.assertEquals( circle.current.prev.value, 5 )
        luaunit.assertEquals( circle.current.value, 7 )
        luaunit.assertEquals( circle.current.next.value, 12 )
        luaunit.assertEquals( circle.size, 3 )
    end

    function TestPuzzle:testMoveBackwardOnce()
        circle = self:getListOfFiveSevenTwelve()
        circle:moveBackward(1)
        luaunit.assertEquals( circle.current.prev.value, 5 )
        luaunit.assertEquals( circle.current.value, 7 )
        luaunit.assertEquals( circle.current.next.value, 12 )
        luaunit.assertEquals( circle.size, 3 )
    end

    function TestPuzzle:testMoveBackwardTwice()
        circle = TestPuzzle:getListOfFiveSevenTwelve()
        circle:moveBackward(2)
        luaunit.assertEquals( circle.current.prev.value, 12 )
        luaunit.assertEquals( circle.current.value, 5 )
        luaunit.assertEquals( circle.current.next.value, 7 )
        luaunit.assertEquals( circle.size, 3 )
    end

    function TestPuzzle:testIsToreCircle()
        circle = TestPuzzle:getListOfFiveSevenTwelve()
        circle:moveForward(25)
        luaunit.assertEquals( circle.current.prev.value, 12 )
        luaunit.assertEquals( circle.current.value, 5 )
        luaunit.assertEquals( circle.current.next.value, 7 )
        luaunit.assertEquals( circle.size, 3 )
    end

    function TestPuzzle:testRemove()
        circle = TestPuzzle:getListOfFiveSevenTwelve()
        circle:add(puzzle_core.Node:new(23))
        luaunit.assertEquals( circle.size, 4 )
        local removed_node = circle:remove()
        luaunit.assertEquals( removed_node.value, 23 )
        luaunit.assertEquals( removed_node.next, nil )
        luaunit.assertEquals( removed_node.prev, nil )
        luaunit.assertEquals( circle.current.prev.value, 12 )
        luaunit.assertEquals( circle.current.value, 5 )
        luaunit.assertEquals( circle.current.next.value, 7 )
        luaunit.assertEquals( circle.size, 3 )
    end

    function TestPuzzle:testPlayTwoMarbles()
        circle = puzzle_core.CircleList:new()
        circle:add(puzzle_core.Node:new(0))

        player = puzzle_core.Player:new(1)
        player:play(circle, 1)

        luaunit.assertEquals( circle.current.prev.value, 0 )
        luaunit.assertEquals( circle.current.value, 1 )
        luaunit.assertEquals( circle.current.next.value, 0 )
        luaunit.assertEquals( circle.size, 2 )
    end

    function TestPuzzle:testPlayThreeMarbles()
        circle = puzzle_core.CircleList:new()
        circle:add(puzzle_core.Node:new(0))

        player = puzzle_core.Player:new(1)
        player:play(circle, 1)
        player:play(circle, 2)

        luaunit.assertEquals( circle.current.prev.value, 0 )
        luaunit.assertEquals( circle.current.value, 2 )
        luaunit.assertEquals( circle.current.next.value, 1 )
        luaunit.assertEquals( circle.size, 3 )
    end

    function TestPuzzle:testPlayTwentyMarbles()
        circle = puzzle_core.CircleList:new()
        circle:add(puzzle_core.Node:new(0))

        player = puzzle_core.Player:new(1)
        for i=1,20 do
            player:play(circle, i)
        end

        luaunit.assertEquals( circle.current.prev.value, 2 )
        luaunit.assertEquals( circle.current.value, 20 )
        luaunit.assertEquals( circle.current.next.value, 10 )
        luaunit.assertEquals( circle.size, 21 )
    end

    function TestPuzzle:testPlayTwentyThreeMarbles()
        circle = puzzle_core.CircleList:new()
        circle:add(puzzle_core.Node:new(0))

        player = puzzle_core.Player:new(1)
        for i=1,23 do
            player:play(circle, i)
        end

        luaunit.assertEquals( circle.current.prev.value, 18 )
        luaunit.assertEquals( circle.current.value, 19 )
        luaunit.assertEquals( circle.current.next.value, 2 )
        luaunit.assertEquals( circle.size, 22 )
        luaunit.assertEquals( player.score, 32 )
    end

    function TestPuzzle:testPlayTwentyFiveMarbles()
        circle = puzzle_core.CircleList:new()
        circle:add(puzzle_core.Node:new(0))

        player = puzzle_core.Player:new(1)
        for i=1,25 do
            player:play(circle, i)
        end

        luaunit.assertEquals( circle.current.value, 25 )
        luaunit.assertEquals( circle.current.next.value, 10 )
        luaunit.assertEquals( circle.current.prev.value, 20 )
        luaunit.assertEquals( circle.size, 24 )
        luaunit.assertEquals( player.score, 32 )
    end

    function TestPuzzle:testResolvePuzzle()
        assert( puzzle_core.ResolvePuzzle(9, 25), 32)
        assert( puzzle_core.ResolvePuzzle(10, 1618), 8317)
        assert( puzzle_core.ResolvePuzzle(13, 7999), 146373)
        assert( puzzle_core.ResolvePuzzle(17, 1104), 2764)
        assert( puzzle_core.ResolvePuzzle(21, 6111), 54718)
        assert( puzzle_core.ResolvePuzzle(30, 5807), 37305)
    end
-- class TestPuzzle

os.exit( luaunit.LuaUnit.run() )
