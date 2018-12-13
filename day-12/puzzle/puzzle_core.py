import array

def extractInt(s):
    val = 0
    for c in s:
        val = val << 1
        if c == '#':
            val |= 1
    return val

class Nursery:
    def __init__(self, initialState, origin):
        self.origin = origin
        self.firstPlantIndex = origin
        self.bitArray = BitArray(self.origin + len(initialState))
        index = 0
        for c in initialState:
            if c == '#':
                self.bitArray.setBit(self.origin + index)
            index += 1
    
    def toString(self):
        s = ""
        for i in range(0, self.bitArray.length):
            if self.bitArray.testBit(i):
                s += "#"
            else:
                s += "."
        return(s)
   
    def lastAlivePlant(self):
        # print("lastAlivePlant : ", self.toString())
        for i in reversed(range(0, self.bitArray.length)):
            # print("testBit with bit_num ", i, " is ", self.bitArray.testBit(i))
            if self.bitArray.testBit(i):
                return i
        return 0

    def nextGen(self, notes):
        nextLength = self.lastAlivePlant() + 4
        nextBitArray = BitArray(nextLength)
        firstPlantFound = False
        for i in range(self.firstPlantIndex - 2, nextLength + 2):
            if self.bitArray.getValue(i) in notes:
                if not firstPlantFound:
                    self.firstPlantIndex = i
                firstPlantFound = True
                nextBitArray.setBit(i)

        self.bitArray = nextBitArray
        self.length = nextBitArray.length

    def count(self):
        count = 0
        for i in range(self.firstPlantIndex, self.lastAlivePlant()+1):
            # print(i, " is ", self.bitArray.testBit(i))
            if self.bitArray.testBit(i):
                count += (i - self.origin)
        return count






class BitArray:
    def __init__(self, length):
        self.length = length
        intSize = 2 + (length >> 5)
        self.count = 0;
        self.content = array.array('I')          # 'I' = unsigned 32-bit integer
        self.content.extend((0,) * intSize)

    # testBit() returns a nonzero result, 2**offset, if the bit at 'bit_num' is set to 1.
    def testBit(self, bit_num):
        bit = self.content[bit_num >> 5] & (1 << (bit_num & 31))
        # print("testBit with bit_num ", bit_num, " is ", bit)
        return( bit > 0 )

    # setBit() returns an integer with the bit at 'bit_num' set to 1.
    def setBit(self, bit_num):
        self.count += 1
        self.content[bit_num >> 5] |= 1 << (bit_num & 31)

    # clearBit() returns an integer with the bit at 'bit_num' cleared.
    def clearBit(self, bit_num):
        self.count -= 1
        self.content[bit_num >> 5] &= ~(1 << (bit_num & 31))

    def getValue(self, bit_num):
        val = 0
        # print("loop over bit from bit ", bit_num-2, " to bit ", bit_num+2)
        for i in range(bit_num-2, bit_num+2+1):
            # print("bit ", i, " is ", self.testBit(i))
            val = val << 1;
            if self.testBit(i) == 1:
                # print("bit ", i, " is 1")
                val |= 1
            else:
                # print("bit ", i, " is 0")
                val |= 0
        return val

