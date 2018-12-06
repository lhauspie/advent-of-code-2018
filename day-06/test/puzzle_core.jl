using Test

include("../src/puzzle_core.jl")

@testset "All tests" begin
    @testset "puzzle_core#get_new_cell_value tests" begin
        @testset "0, 1 => 1" begin
            @test get_new_cell_value(0,1) == 1
        end;

        @testset "0, 2 => 2" begin
            @test get_new_cell_value(0,2) == 2
        end;

        @testset "1, 0 => 1" begin
            @test get_new_cell_value(1,0) == 1
        end;

        @testset "-1, 1 => -1" begin
            @test get_new_cell_value(-1,1) == -1
        end;

        @testset "1, 2 => -1" begin
            @test get_new_cell_value(1,2) == -1
        end;

        @testset "1, 1 => 1" begin
            @test get_new_cell_value(1,1) == 1
        end;
    end;

    @testset "puzzle_core#next_step tests" begin
        @testset "1 se répend" begin
            initial_board = [
                1 0;
                0 0
            ]

            expected_board = [
                1 1;
                1 0
            ]

            @test next_step(initial_board) == expected_board
        end;

        @testset "2 se répend" begin
            initial_board = [
                2 0;
                0 0
            ]
            expected_board = [
                2 2;
                2 0
            ]
            @test next_step(initial_board) == expected_board
        end;

        @testset "2 ne se répend pas mais 1 oui" begin
            initial_board = [
                2 1;
                1 0
            ]
            expected_board = [
                2 1;
                1 1
            ]
            @test next_step(initial_board) == expected_board
        end;

        @testset "1 ne se répend pas à cause de 2 concurent de 1" begin
            initial_board = [
                2 2;
                1 0
            ]
            expected_board = [
                2 2;
                1 -1
            ]
            @test next_step(initial_board) == expected_board
        end;

        @testset "1 et 2 ne se répendent" begin
            initial_board = [
                2 0;
                0 1
            ]
            expected_board = [
                2 -1;
                -1 1
            ]
            @test next_step(initial_board) == expected_board
        end;

        @testset "-1 n'impacte pas la propagation" begin
            initial_board = [
                0 -1;
                1 0
            ]
            expected_board = [
                1 -1;
                1 1
            ]
            @test next_step(initial_board) == expected_board
        end;

        @testset "1 se répend dans toutes les directions" begin
            initial_board = [
                0 0 0;
                0 1 0;
                0 0 0
            ]
            expected_board = [
                0 1 0;
                1 1 1;
                0 1 0
            ]
            @test next_step(initial_board) == expected_board
        end;

        @testset "1 se répend uniquement vers le bas" begin
            initial_board = [
                2 0 0;
                0 1 0;
                0 0 0
            ]
            expected_board = [
                2 -1 0;
                -1 1 1;
                0 1 0
            ]
            @test next_step(initial_board) == expected_board
        end;
    end;

    @testset "puzzle_core#is_complete tests" begin
        @test is_complete([
            0 0;
            0 0
        ]) == false

        @test is_complete([
            2 2;
            1 0
        ]) == false

        @test is_complete([
            2 2;
            1 -1
        ]) == true

        @test is_complete([
            2 2;
            1 -1
        ]) == true

        @test is_complete([
            2 2;
            2 2
        ]) == true
    end;

    @testset "puzzle_core#expands_entities_area tests" begin
        @testset "empty board is not buging" begin
            @test expands_entities_area([]) == []
        end

        @testset "1 element" begin
            initial_board = [
                [1]
            ]
            expected_board = [
                [1]
            ]
            @test expands_entities_area(initial_board) == expected_board
        end;

        @testset "1 se répend" begin
            initial_board = [
                1 0;
                0 0
            ]
            expected_board = [
                1 1;
                1 1
            ]
            @test expands_entities_area(initial_board) == expected_board
        end;

        @testset "2 se répend" begin
            initial_board = [
                2 0;
                0 0
            ]
            expected_board = [
                2 2;
                2 2
            ]
            @test expands_entities_area(initial_board) == expected_board
        end;

        @testset "2 ne se répend pas mais 1 oui" begin
            initial_board = [
                2 1;
                1 0
            ]
            expected_board = [
                2 1;
                1 1
            ]
            @test expands_entities_area(initial_board) == expected_board
        end;

        @testset "1 ne se répend pas à cause de 2 concurent de 1" begin
            initial_board = [
                2 2;
                1 0
            ]
            expected_board = [
                2 2;
                1 -1
            ]
            @test expands_entities_area(initial_board) == expected_board
        end;

        @testset "1 et 2 ne se répendent" begin
            initial_board = [
                2 0;
                0 1
            ]
            expected_board = [
                2 -1;
                -1 1
            ]
            @test expands_entities_area(initial_board) == expected_board
        end;

        @testset "1 se répend dans toutes les directions" begin
            initial_board = [
                0 0 0;
                0 1 0;
                0 0 0
            ]
            expected_board = [
                1 1 1;
                1 1 1;
                1 1 1
            ]
            @test expands_entities_area(initial_board) == expected_board
        end;

        @testset "1 se répend uniquement vers le bas" begin
            initial_board = [
                2 0 0;
                0 1 0;
                0 0 0
            ]
            expected_board = [
                2 -1 1;
                -1 1 1;
                1 1 1
            ]
            @test expands_entities_area(initial_board) == expected_board
        end;
    end;

    @testset "puzzle_core#get_entities" begin
        @testset "empty board return no entites" begin
            @test get_entities(reshape([],0,2), []) == []
        end;

        @testset "only open area return no entites" begin
            board = [
                2 1 0;
                1 1 1;
                0 1 0
            ]
            @test get_entities(board, [true, true]) == [false, false]
        end;


        @testset "one open area remove only the good entity" begin
            board = [
                1 1 1 1 1 1;
                1 1 2 1 1 1;
                1 2 2 2 1 1;
                1 1 1 1 1 1;
                1 1 1 1 1 1
            ]
            @test get_entities(board, [true, true]) == [false, true]
        end;
    end;

    @testset "puzzle_core#get_max_area" begin
        @testset "one area of 4*1 and entity is in closed area" begin
            board = [
                1 1;
                1 1
            ]
            @test get_max_area(board, [true]) == 4
        end;
        @testset "one area of 4*1 but entity is in open area" begin
            board = [
                1 1;
                1 1
            ]
            @test get_max_area(board, [false]) == 0
        end;
        @testset "two area of 1*1 + 3*2 but entity 1 is in open area and entity 2 in closed area" begin
            board = [
                1 2;
                2 2
            ]
            @test get_max_area(board, [false, true]) == 3
        end;
    end;


    @testset "puzzle_core#count_area" begin
        @testset "count 4*1 (1) return 4 and (2) return 0" begin
            board = [
                1 1;
                1 1
            ]
            @test count_area(board, 1) == 4
            @test count_area(board, 2) == 0
        end;

        @testset "count 3*1+1*2 (1) return 3" begin
            board = [
                1 1;
                1 2
            ]
            @test count_area(board, 1) == 3
        end;

        @testset "count 4*2 (1) return 0" begin
            board = [
                2 2;
                2 2
            ]
            @test count_area(board, 1) == 0
        end;
    end;

    @testset "puzzle_core#mark_closer_area" begin
        @testset "distance 1" begin
            entities = [Entity(1, 1), Entity(1, 2)]
            initial_board = [
                0 0 0;
                0 0 0;
                0 0 0
            ]
            expected_board = [
                1 1 0;
                0 0 0;
                0 0 0
            ]
            @test mark_closer_area(initial_board, entities, 1) == expected_board
        end;
        @testset "distance 2" begin
            entities = [Entity(1, 1), Entity(1, 3)]
            initial_board = [
                0 0 0;
                0 0 0;
                0 0 0
            ]
            expected_board = [
                1 1 1;
                0 0 0;
                0 0 0
            ]
            @test mark_closer_area(initial_board, entities, 2) == expected_board
        end;
        @testset "distance 4" begin
            entities = [Entity(1, 1), Entity(1, 3)]
            initial_board = [
                0 0 0;
                0 0 0;
                0 0 0
            ]
            expected_board = [
                1 1 1;
                1 1 1;
                0 0 0
            ]
            @test mark_closer_area(initial_board, entities, 4) == expected_board
        end;
    end;
end;
