function output(text) {
    document.getElementById("output").innerText=text;
}

function sayHello(budy) {
    return "Hello, "+budy+"!";
}

function oprr(op, instruction, registers) { registers[instruction[3]] = op(registers[instruction[1]], registers[instruction[2]]) }
function opri(op, instruction, registers) { registers[instruction[3]] = op(registers[instruction[1]], instruction[2]) }
function opir(op, instruction, registers) { registers[instruction[3]] = op(instruction[1], registers[instruction[2]]) }
function opii(op, instruction, registers) { registers[instruction[3]] = op(instruction[1], instruction[2]) }

function add(a,b) {return a+b}
function sub(a,b) {return a-b}
function mul(a,b) {return a*b}
function mul(a,b) {return a*b}
function set(a,b) {return a}
function eq(a,b) {return a==b ? 1 : 0}
function ban(a,b) {return a&b}
function bor(a,b) {return a|b}
function gt(a,b) {return a>b ? 1 : 0}

function addr(instruction, registers) { return oprr(add, instruction, registers)}
function addi(instruction, registers) { return opri(add, instruction, registers)}
function seti(instruction, registers) { return opii(set, instruction, registers)}
function setr(instruction, registers) { return opri(set, instruction, registers)}
function eqri(instruction, registers) { return opri(eq, instruction, registers)}
function eqrr(instruction, registers) { return oprr(eq, instruction, registers)}
function bani(instruction, registers) { return opri(ban, instruction, registers)}
function bori(instruction, registers) { return opri(bor, instruction, registers)}
function muli(instruction, registers) { return opri(mul, instruction, registers)}
function gtrr(instruction, registers) { return oprr(gt, instruction, registers)}
function gtir(instruction, registers) { return opir(gt, instruction, registers)}


function execute(instruction, registers) {
    functions[instruction[0]](instruction, registers);
}

var functions = {
    "addr": addr,
    "addi": addi,
    "seti": seti,
    "setr": setr,
    "eqri": eqri,
    "eqrr": eqrr,
    "bani": bani,
    "bori": bori,
    "muli": muli,
    "gtrr": gtrr,
    "gtir": gtir
}

function resolve() {
    var lines = document.getElementById('input').value.split('\n');
    var instruction_pointer_index = parseInt(lines[0].split(' ')[1], 10);
    var instructions = [];
    for(var i = 1; i < lines.length; i++) {
        var instruction = lines[i].split(' ');
        // console.log(instruction);
        for (var j = 1; j < instruction.length; j++) {
            // console.log(instruction[j]);
            instruction[j] = parseInt(instruction[j], 10);
        }
        instructions[i-1] = instruction;
    }
    

    var registers = [0,0,0,0,0,0,0];

    var haltingValues = [];
    var haltingIndex = 0;

    var step1 = null;
    var step2 = null;
    while (!step1 || !step2) {
        if (registers[instruction_pointer_index] == 28) {
            if (!step1) {
                step1 = registers[5];
            }
            if (haltingValues.includes(registers[5])) {
                step2 = haltingValues[haltingIndex-1];
            }
            haltingValues[haltingIndex] = registers[5];
            haltingIndex++;
        }

        execute(instructions[registers[instruction_pointer_index]], registers);
        registers[instruction_pointer_index]++;
    }
    return "Step 1 : " + step1 + " | Step 2 : "+ step2;
}