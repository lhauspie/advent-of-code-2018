package com.lhauspie.adventofcode

import java.io.File

class Puzzle {
    companion object {
        const val OPCODE = 0
        const val INPUT_A = 1
        const val INPUT_B = 2
        const val OUTPUT_C = 3
    }

    val greater_than_op = { a: Int, b: Int -> if (a > b) 1 else 0 }
    val equals_op = { a: Int, b: Int -> if (a == b) 1 else 0 }
    val affectation = { a: Int, _: Int -> a }

    fun internal_oprr(registers: IntArray, instruction: IntArray, op: (Int, Int) -> Int) : IntArray? {
        if (instruction[INPUT_A] > registers.size
                || instruction[INPUT_B] > registers.size
                || instruction[OUTPUT_C] > registers.size) {
            return null
        }
        var result = registers.copyOf()
        result[instruction[OUTPUT_C]] = op(registers[instruction[INPUT_A]], registers[instruction[INPUT_B]])
        return result
    }

    fun internal_opri(registers: IntArray, instruction: IntArray, op: (Int, Int) -> Int) : IntArray? {
        if (instruction[INPUT_A] > registers.size
                || instruction[OUTPUT_C] > registers.size) {
            return null
        }
        var result = registers.copyOf()
        result[instruction[OUTPUT_C]] = op(registers[instruction[INPUT_A]], instruction[INPUT_B])
        return result
    }

    fun internal_opir(registers: IntArray, instruction: IntArray, op: (Int, Int) -> Int) : IntArray? {
        if (instruction[INPUT_B] > registers.size
                || instruction[OUTPUT_C] > registers.size) {
            return null
        }
        var result = registers.copyOf()
        result[instruction[OUTPUT_C]] = op(instruction[INPUT_A], registers[instruction[INPUT_B]])
        return result
    }

    fun internal_opii(registers: IntArray, instruction: IntArray, op: (Int, Int) -> Int) : IntArray? {
        if (instruction[OUTPUT_C] > registers.size) {
            return null
        }
        var result = registers.copyOf()
        result[instruction[OUTPUT_C]] = op(instruction[INPUT_A], instruction[INPUT_B])
        return result
    }

    val addr = { registers: IntArray, instruction: IntArray -> internal_oprr(registers, instruction, Int::plus)}
    val addi = { registers: IntArray, instruction: IntArray -> internal_opri(registers, instruction, Int::plus)}
    val mulr = { registers: IntArray, instruction: IntArray -> internal_oprr(registers, instruction, Int::times)}
    val muli = { registers: IntArray, instruction: IntArray -> internal_opri(registers, instruction, Int::times)}
    val banr = { registers: IntArray, instruction: IntArray -> internal_oprr(registers, instruction, Int::and)}
    val bani = { registers: IntArray, instruction: IntArray -> internal_opri(registers, instruction, Int::and)}
    val borr = { registers: IntArray, instruction: IntArray -> internal_oprr(registers, instruction, Int::or)}
    val bori = { registers: IntArray, instruction: IntArray -> internal_opri(registers, instruction, Int::or)}
    val setr = { registers: IntArray, instruction: IntArray -> internal_opri(registers, instruction, affectation)}
    val seti = { registers: IntArray, instruction: IntArray -> internal_opii(registers, instruction, affectation)}
    val gtrr = { registers: IntArray, instruction: IntArray -> internal_oprr(registers, instruction, greater_than_op)}
    val gtri = { registers: IntArray, instruction: IntArray -> internal_opri(registers, instruction, greater_than_op)}
    val gtir = { registers: IntArray, instruction: IntArray -> internal_opir(registers, instruction, greater_than_op)}
    val eqrr = { registers: IntArray, instruction: IntArray -> internal_oprr(registers, instruction, equals_op)}
    val eqri = { registers: IntArray, instruction: IntArray -> internal_opri(registers, instruction, equals_op)}
    val eqir = { registers: IntArray, instruction: IntArray -> internal_opir(registers, instruction, equals_op)}

    val operations = hashMapOf(
        "addr" to addr,
        "addi" to addi,
        "mulr" to mulr,
        "muli" to muli,
        "banr" to banr,
        "bani" to bani,
        "borr" to borr,
        "bori" to bori,
        "setr" to setr,
        "seti" to seti,
        "gtrr" to gtrr,
        "gtri" to gtri,
        "gtir" to gtir,
        "eqrr" to eqrr,
        "eqri" to eqri,
        "eqir" to eqir
    )

    val opCodeToOperationsMap: MutableMap<Int, MutableList<String>> = hashMapOf()
    init {
        for (opCode in 0..15) {
            opCodeToOperationsMap.put(opCode, operations.keys.toMutableList())
        }
    }

    fun retroEngineOpCodes(before: IntArray, instruction: IntArray, after: IntArray) {
        val currentOpCode = instruction.get(0)
        var currentListOfOpCode: MutableList<String> = opCodeToOperationsMap.get(currentOpCode)!!
        var nextListOfOperations = mutableListOf<String>()

        for (opCode in currentListOfOpCode) {
            val operation = operations.get(opCode)!!
            val result = operation(before, instruction)
            if (result != null && result.contentEquals(after)) {
                nextListOfOperations.add(opCode)
            }
        }

        opCodeToOperationsMap.put(currentOpCode, nextListOfOperations)
    }

    fun numberOfMatchingOpCodes(before: IntArray, instruction: IntArray, after: IntArray) : Int {
        var count = 0;
        for ((opCode, operation) in operations) {
            val result = operation(before, instruction)
            if (result != null && result.contentEquals(after)) {
                // println(before.joinToString() + "/" + instruction.joinToString() + "/" + after.joinToString() + " matches " + opCode)
                count++
            } else {
                // println(before.joinToString() + "/" + instruction.joinToString() + "/" + after.joinToString() + " doesn't match " + opCode)
            }
        }

        retroEngineOpCodes(before, instruction, after)
        return count
    }

    fun extractBefore(str: String): IntArray {
        // "Before: [1, 1, 0, 1]"
        return str.replace("Before: [", "")
                .replace("]", "").split(", ")
                .map({
                    it.toInt()
                })
                .toIntArray()
    }

    fun extractInstruction(str: String): IntArray {
        return str.split(" ")
                .map({
                    it.toInt()
                })
                .toIntArray()
    }

    fun extractAfter(str: String): IntArray {
        // "After: [1, 1, 0, 1]"
        return str.replace("After:  [", "")
                .replace("]", "").split(", ")
                .map({
                    it.toInt()
                })
                .toIntArray()
    }

    fun getOperationsByOpCode() : Map<Int, (IntArray, IntArray) -> IntArray?>{
        do  {
            var opCodesWithOneOperation = opCodeToOperationsMap.filter({ it.value.size == 1 })
            for ((_, strOpCodes) in opCodesWithOneOperation) {
                val strOpCode = strOpCodes.get(0)
                for ((_, subOperations) in opCodeToOperationsMap) {
                    if (subOperations.size > 1) {
                        subOperations.remove(strOpCode)
                    }
                }
            }
        } while (opCodesWithOneOperation.size < 16) // commentaire de gruge pour avoir la coloration syntaxique suite au while >

        // transform Map<Int, List<String>> to Map<Int, (IntArray, IntArray) -> IntArray?>
        var result = hashMapOf<Int, (IntArray, IntArray) -> IntArray?>()
        for ((opCode, strOpCodes) in opCodeToOperationsMap) {
            result.put(opCode, operations.get(strOpCodes.get(0)!!)!!)
        }

        return result
    }
}