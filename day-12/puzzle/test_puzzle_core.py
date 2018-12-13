import unittest
from puzzle_core import *

class TestPuzzleMethods(unittest.TestCase):

    def test_extractIntFromString(self):
        self.assertEqual(extractInt('.....'), 0)
        self.assertEqual(extractInt("..#.."), 4)
        self.assertEqual(extractInt("#.#.."), 20)
        self.assertEqual(extractInt("#####"), 31)
    
    def test_createBitArray_with0(self):
        bitArray = BitArray(5)
        self.assertEqual(len(bitArray.content), 2)
        self.assertEqual(bitArray.content[0], 0)
        self.assertEqual(bitArray.length, 5)

    def test_testBit(self):
        bitArray = BitArray(5)
        bitArray.setBit(2)
        self.assertEqual(bitArray.testBit(0), 0)
        self.assertEqual(bitArray.testBit(1), 0)
        self.assertEqual(bitArray.testBit(2), 1)
        self.assertEqual(bitArray.testBit(3), 0)
        self.assertEqual(bitArray.testBit(4), 0)

    def test_getValue(self):
        bitArray = BitArray(5)
        bitArray.setBit(2)
        self.assertEqual(bitArray.getValue(-2), 0)
        self.assertEqual(bitArray.getValue(-1), 0)
        self.assertEqual(bitArray.getValue(0), 1)
        self.assertEqual(bitArray.getValue(1), 2)
        self.assertEqual(bitArray.getValue(2), 4)
        self.assertEqual(bitArray.getValue(3), 8)
        self.assertEqual(bitArray.getValue(4), 16)
        self.assertEqual(bitArray.getValue(5), 0)
        self.assertEqual(bitArray.getValue(5), 0)

    def test_getValue_bis(self):
        bitArray = BitArray(32)
        bitArray.setBit(31)
        self.assertEqual(bitArray.getValue(31), 4)
        self.assertEqual(bitArray.getValue(32), 8)
        self.assertEqual(bitArray.getValue(33), 16)
        self.assertEqual(bitArray.getValue(34), 0)

    def test_getValue_ter(self):
        bitArray = BitArray(5)
        bitArray.setBit(0)
        self.assertEqual(bitArray.getValue(-2), 1)
        self.assertEqual(bitArray.getValue(-1), 2)
        self.assertEqual(bitArray.getValue(0), 4)
        self.assertEqual(bitArray.getValue(1), 8)
        self.assertEqual(bitArray.getValue(2), 16)
        self.assertEqual(bitArray.getValue(3), 0)

    def test_NurseryInit(self):
        self.assertEqual(Nursery("#...#..#", 0).count(), 0+4+7)
        self.assertEqual(Nursery("########", 0).count(), 0+1+2+3+4+5+6+7)
        self.assertEqual(Nursery("########", 1).count(), 0+1+2+3+4+5+6+7)
        self.assertEqual(Nursery("########", 3).count(), 0+1+2+3+4+5+6+7)

    def test_NurseryToString(self):
        self.assertEqual(Nursery("#...#..#", 0).toString(), "#...#..#")
        self.assertEqual(Nursery("########", 0).toString(), "########")

    def test_NurseryLastPlantAlive(self):
        self.assertEqual(Nursery("#...#..#", 0).lastAlivePlant(), 7)
        self.assertEqual(Nursery("#...#...", 0).lastAlivePlant(), 4)
        self.assertEqual(Nursery("#...#..#", 3).lastAlivePlant(), 10)
        self.assertEqual(Nursery("#...#...", 3).lastAlivePlant(), 7)

    def test_NurseryNextGen(self):
        # 00010 => 1
        # 00101 => 1
        notes = [2, 5]
        
        nursery = Nursery("..#.#", 0)
        nursery.nextGen(notes)
        self.assertEqual(nursery.toString(), ".##.....")
        self.assertEqual(nursery.count(), 3)
        
    def test_NurseryTwoNextGen(self):
        # 00010 => 1
        # 00101 => 1
        notes = [2, 5]
        
        nursery = Nursery("..#.#", 0)
        nursery.nextGen(notes)
        nursery.nextGen(notes)
        self.assertEqual(nursery.toString(), "......")
        self.assertEqual(nursery.count(), 0)

    def test_NurseryNextGen_withOrigin(self):
        # 00010 => 1
        # 00101 => 1
        notes = [2, 5]
        
        nursery = Nursery("..#.#", 8)
        nursery.nextGen(notes)
        self.assertEqual(nursery.toString(), ".........##.....")
        self.assertEqual(nursery.count(), 3)
        
    def test_NurseryTwoNextGen_withOrigin(self):
        # 00010 => 1
        # 00101 => 1
        notes = [2, 5]
        
        nursery = Nursery("..#.#", 8)
        nursery.nextGen(notes)
        nursery.nextGen(notes)
        self.assertEqual(nursery.toString(), "..............")
        self.assertEqual(nursery.count(), 0)

    def test_AdventOfCode_step0(self):
        notes = [3, 4, 8, 10, 11, 12, 15, 21, 23, 26, 27, 28, 29, 30]
        nursery = Nursery("#..#.#..##......###...###", 0)
        self.assertEqual(nursery.count(), 0+3+5+8+9+16+17+18+22+23+24)

    def test_AdventOfCode_step1(self):
        notes = [3, 4, 8, 10, 11, 12, 15, 21, 23, 26, 27, 28, 29, 30]
        nursery = Nursery("#..#.#..##......###...###", 0)
        nursery.nextGen(notes) # ==> #...#....#.....#..#..#..#...........
        print(nursery.toString())
        self.assertEqual(nursery.count(), (0+4+9+15+18+21+24))

    def test_AdventOfCode(self):
        notes = [3, 4, 8, 10, 11, 12, 15, 21, 23, 26, 27, 28, 29, 30]
        nursery = Nursery("#..#.#..##......###...###", 0)
        for i in range (0, 20):
            nursery.nextGen(notes)
        self.assertEqual(nursery.count(), 325)        

    def test_AdventOfCode_withOrigin(self):
        notes = [3, 4, 8, 10, 11, 12, 15, 21, 23, 26, 27, 28, 29, 30]
        nursery = Nursery("#..#.#..##......###...###", 10)
        for i in range (0, 20):
            nursery.nextGen(notes)
        self.assertEqual(nursery.count(), 325)        


suite = unittest.TestLoader().loadTestsFromTestCase(TestPuzzleMethods)
unittest.TextTestRunner(verbosity=2).run(suite)
