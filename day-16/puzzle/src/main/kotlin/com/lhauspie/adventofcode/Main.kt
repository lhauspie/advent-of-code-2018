package com.lhauspie.adventofcode

import java.io.File

class Main {
    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val puzzle = Puzzle();

            println(File("input.txt").getAbsolutePath())
            val fileLines = File("input.txt").readLines()

            var i = 0
            var count = 0
            var total = 0
            while (fileLines.get(i).startsWith("Before")) {
                total++
                val before = puzzle.extractBefore(fileLines.get(i))
                val instruction = puzzle.extractInstruction(fileLines.get(i+1))
                val after = puzzle.extractAfter(fileLines.get(i+2))
                if (puzzle.numberOfMatchingOpCodes(before, instruction, after) >= 3) {
                    count++
                }
                i += 4
            }
            
            println(count.toString() + "/" + total + " samples behave like three or more opCodes")




            i+=2
            val operationsByOpCode = puzzle.getOperationsByOpCode()

            var registers = intArrayOf(0, 0, 0, 0)
            while (i < fileLines.size) { // commentaire de gruge pour avoir la coloration syntaxique suite au while >
                var instruction = puzzle.extractInstruction(fileLines.get(i))
                val opCode = instruction.get(0)
                val operation = operationsByOpCode.get(opCode)!!
                registers = operation(registers, instruction)!!
                i++
            }
            println("registers : " + registers.joinToString())
        }
    }
}