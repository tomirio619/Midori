def Sb0(bitStringArray):
    x = int("".join((map(str, bitStringArray))), 2)
    if x == 0:
        result = int("c", 16)
    elif x == 1:
        result = int("a", 16)
    elif x == 2:
        result = int("d", 16)
    elif x == 3:
        result = 3
    elif x == 4:
        result = int("e", 16)
    elif x == 5:
        result = int("d", 16)
    elif x == 6:
        result = int("f", 16)
    elif x == 7:
        result = 7
    elif x == 8:
        result = 8
    elif x == 9:
        result = 9
    elif x == int("a", 16):
        result = 1
    elif x == int("b", 16):
        result = 5
    elif x == int("c", 16):
        result = 0
    elif x == int("d", 16):
        result = 2
    elif x == int("e", 16):
        result = 4
    elif x == int("f", 16):
        result = 6
    else:
        raise Exception("The value {} does not have a corresponding value in the lookup table".format(x))
    b0 = (result >> 3) & 1
    b1 = (result >> 2) & 1
    b2 = (result >> 1) & 1
    b3 = result & 1
    newBitStringArray = list(map(str, [b0, b1, b2, b3]))
    return newBitStringArray


def Sb1(bitStringArray):
    x = int("".join((map(str, bitStringArray))), 2)
    if x == 0:
        result = 1
    elif x == 1:
        result = 0
    elif x == 2:
        result = 5
    elif x == 3:
        result = 3
    elif x == 4:
        result = int("e", 16)
    elif x == 5:
        result = 2
    elif x == 6:
        result = int("f", 16)
    elif x == 7:
        result = 7
    elif x == 8:
        result = int("d", 16)
    elif x == 9:
        result = int("a", 16)
    elif x == int("a", 16):
        result = 9
    elif x == int("b", 16):
        result = int("b", 16)
    elif x == int("c", 16):
        result = int("c", 16)
    elif x == int("d", 16):
        result = 8
    elif x == int("e", 16):
        result = 4
    elif x == int("f", 16):
        result = 6
    else:
        raise Exception("The value {} does not have a corresponding value in the lookup table".format(x))
    b0 = (result >> 3) & 1
    b1 = (result >> 2) & 1
    b2 = (result >> 1) & 1
    b3 = result & 1
    newBitStringArray = list(map(str, [b0, b1, b2, b3]))
    return newBitStringArray
