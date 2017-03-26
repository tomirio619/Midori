from math import floor

import numpy as np

from constants import roundConstants
from sboxes import Sb1


def SSbi(x, i):
    """
    Implements the Sbox within midori.
    :param x: The integer that is fed into the sbox
    :param i: Indicates which sbox must be used
    :return: A permuted x
    """
    # x0 is the most significant bit, x7 the least significant
    x0 = (x >> 7) & 1
    x1 = (x >> 6) & 1
    x2 = (x >> 5) & 1
    x3 = (x >> 4) & 1
    x4 = (x >> 3) & 1
    x5 = (x >> 2) & 1
    x6 = (x >> 1) & 1
    x7 = x & 1
    binResult = []
    if i == 0:
        n0 = Sb1([x4, x1, x6, x3])
        n1 = Sb1([x0, x5, x2, x7])
        binResult = [n1[0], n0[1], n1[2], n0[3],
                     n0[0], n1[1], n0[2], n1[3]]
    elif i == 1:
        n0 = Sb1([x1, x6, x7, x0])
        n1 = Sb1([x5, x2, x3, x4])
        binResult = [n0[3], n0[0], n1[1], n1[2],
                     n1[3], n1[0], n0[1], n0[2]]
    elif i == 2:
        n0 = Sb1([x2, x3, x4, x1])
        n1 = Sb1([x6, x7, x0, x5])
        binResult = [n1[2], n0[3], n0[0], n0[1],
                     n0[2], n1[3], n1[0], n1[1]]
    elif i == 3:
        n0 = Sb1([x7, x4, x1, x2])
        n1 = Sb1([x3, x0, x5, x6])
        binResult = [n1[1], n0[2], n0[3], n1[0],
                     n0[1], n1[2], n1[3], n0[0]]
    result = int("".join(binResult), 2)
    return result


def SubCell(state):
    """
    SSbi is applied 8-bit cell of the state S.
     Namely, si <=  SSb(i mod 4)[si] for Midori128, where 0 <= i <= 15.
    :param state: The state
    :return: A new state in which the permumtation is applied.
    """
    print("SubCell, 'before' state:\n{}\n".format(state))
    for col in range(4):
        for row in range(4):
            i = col * 4 + row
            si = state[row, col]
            permuted = SSbi(si, i % 4)
            state[row, col] = permuted
    print("SubCell, 'after' state:\n{}\n".format(state))
    return state


def ShuffleCell(state):
    """
    Each cell of the state is permuted as follows:
    (s0, s1,..., s15) <=  (s0, s10, s5, s15, s14, s4, s11, s1, s9, s3, s12, s6, s7, s13, s2, s8).
    :param state: The current state matrix S.
    :return: Permuted state matrix S
    """
    print("ShuffleCell, original state:\n{}\n".format(state))
    sDict = {}
    for col in range(4):
        for row in range(4):
            i = col * 4 + row
            sDict['s' + str(i)] = state[row, col]
    newState = np.matrix([
        [sDict['s0'], sDict['s14'], sDict['s9'], sDict['s7']],
        [sDict['s10'], sDict['s4'], sDict['s3'], sDict['s13']],
        [sDict['s5'], sDict['s11'], sDict['s12'], sDict['s2']],
        [sDict['s15'], sDict['s1'], sDict['s6'], sDict['s8']]
    ])
    print("ShuffleCell, new state:\n{}\n".format(newState))
    return newState


def MixColumn(state):
    """
    MixColumn (S): M is applied to every 4m-bit column of the state S, i.e.,
    (si; si+1; si+2; si+3)^T =  M * (si; si+1; si+2; si+3)^T and i = 0; 4; 8; 12.
    Note that the calculations are done in GF(2^8).
    :param state: The current state matrix
    :return: Updated state
    """
    m = np.matrix([
        [0, 1, 1, 1],
        [1, 0, 1, 1],
        [1, 1, 0, 1],
        [1, 1, 1, 0]
    ]
    )
    print("MixColumn, 'before' state:\n{}\n".format(state))
    print("Matrix M is defined as follows\n{}\n".format(m))
    for col in range(4):
        stateCol = np.squeeze(np.asarray(state[:, col]))
        state[:, col] = UpdateColumn(m, stateCol)
    print("MixColumn 'final' state:\n{}\n".format(state))
    return state


def UpdateColumn(m, col):
    results = np.zeros(4, dtype=np.uint8)
    for row in range(4):
        matrixRow = np.squeeze(np.asarray(m[row, :]))
        print("The matrix row:", matrixRow)
        print("The affected column:", col)
        for (a, b) in zip(matrixRow, col):
            results[row] ^= PolyMult(a, b)
    newColumn = np.transpose(np.asmatrix(results))
    return newColumn


def PolyMult(p1, p2):
    """
    Multiply two numbers in the GF(2^8) finite field defined
    by the polynomial x^8 + x^4 + x^3 + x + 1 = 0
    See http://stackoverflow.com/questions/13202758/multiplying-two-polynomials
    :param p1: Polynomial a
    :param p2: Polynomial b
    :return: a * b mod (x^8 + x^4 + x^3 + x + 1)
    """
    PrintPoly(p1)
    print(" * ", end="")
    PrintPoly(p2)
    print(" = ", end="")
    binP2 = bin(p2)[2:].zfill(8)
    mult = 0
    # Base case
    if p1 == 0 or p2 == 0:
        PrintPoly(mult)
        print("\n")
        return 0
    # Perform the multiplication
    for i in range(8):
        bit = binP2[i]
        if bit == "1":
            mult ^= (p1 << (7 - i))
    PrintPoly(mult)
    print("\n")
    # Peform the reduction
    reducPoly = int("100011011", 2)
    while True:
        if GetMSBIndex(mult) < GetMSBIndex(reducPoly):
            break
        elif GetMSBIndex(mult) == GetMSBIndex(reducPoly):
            mult ^= reducPoly
        else:
            degreeDiff = GetMSBIndex(mult) - GetMSBIndex(reducPoly)
            mult ^= (reducPoly << degreeDiff)
    print("After reducing, the result becomes:")
    PrintPoly(mult)
    print("\n")
    return mult


def GetMSBIndex(n):
    """
     Given a bit sequence, indicate the index of the most significant
    set bit, where the index of the least significant bit is zero.
    :param n: The number to determine the MSB bit of.
    :return: index of the MSB of n.
    """
    ndx = 0
    while 1 < n:
        n = (n >> 1)
        ndx += 1
    return ndx


def GetLSBIndex(n):
    """Returns the index, counting from 0, of the
    least significant set bit in `n`.
    """
    return GetMSBIndex(n & -n)


def PrintPoly(n):
    """
    Prints a number in the corresponding polynomial representation.
    In this representation, the MSB bit represents the higest term in the polynomial,
    and the LSB lowest term.
    :param n: number
    """
    if n == 0:
        print("(0)", end="")
        return
    print("(", end="")
    msbIndex = GetMSBIndex(n)
    lsbIndex = GetLSBIndex(n)
    for i in range(msbIndex + 1, 0, -1):
        if (n >> i) & 1 > 0:
            if i >= 10:
                print("x^{{{}}}".format(i), end="")
            else:
                print("x^{}".format(i), end="")
            if i != lsbIndex:
                print(" + ", end="")
    if n & 1 > 0:
        print("1", end="")
    print(")", end="")


def SplitByN(seq, n):
    """
    splits a python string every nth character
    :param seq: the sequence
    :param n: the length of the resulting substrings
    :return: array of substrings of length n
    """
    return [seq[i:i + n] for i in range(0, len(seq), n)]


def StateToBinary(state):
    """
    Converts a state (defined as a 4x4 matrix) to the corresponding binary representation
    :param state: A 4x4 state matrix
    :return: A binary string (without the 0b prefix)
    """
    binary = ""
    for col in range(4):
        for row in range(4):
            si = state[row, col]
            binary += bin(si)[2:].zfill(8)
    return binary


def RoundKeyGen(key):
    """
    Generate the round keys for a given key
    :param key: The initial key (either encryption or decryption
    :return: The round keys derived from the initial key
    """
    roundKeys = []
    keyBytes = SplitByN(key, 8)  # Split current round key into an array of bytes
    for r in range(19):
        rConst = roundConstants[r]
        newRoundKeyBytes = []
        for i in range(16):
            # loop through round constant matrix and XOR with LSB bit of current byte of key
            # Calculate the 2d index from the 1d index
            col = floor(i / 4)
            row = i % 4
            bit = rConst[row, col]  # Take the value from the round constant to add with
            curRoundKeyByte = keyBytes[i]
            # XOR with LSB of the current byte
            newRoundKeyByte = bin(int(curRoundKeyByte, 2) ^ bit)[2:].zfill(8)
            newRoundKeyBytes.append(newRoundKeyByte)
        roundKey = ''.join(newRoundKeyBytes)  # Reconstruct round key
        roundKeys.append(roundKey)
    return roundKeys


def KeyAdd(state, roundKeyI):
    """
    The i-th n-bit round key RKi is XORed to a state S.
    :param state: state S
    :param roundKeyI: The ith round key
    :return: The new state S in which the round key is XORed with the state.
    """
    print("KeyAdd, 'before' state:\n{}\n".format(state))
    roundKeyBytesArray = SplitByN(roundKeyI, 8)
    for col in range(4):
        for row in range(4):
            si = state[row, col]
            roundKeyByte = int(roundKeyBytesArray[col * 4 + row], 2)
            state[row, col] = roundKeyByte ^ si
    print("KeyAdd, 'after' state:\n{}\n".format(state))
    return state


def InitializeState(binaryString):
    """
    Initializes the state with given binary string (which should be padded to a lenght of 128 bits.
    :param binaryString: The binary string
    :return: The state that corresponds to the given binary string.
    """
    state = np.zeros(shape=(4, 4), dtype=np.uint8)
    # Again, s0 contains the 8 most significant bits of the plaintext, and s15 the least significant ones
    plaintextBytes = SplitByN(binaryString, 8)
    for col in range(4):
        for row in range(4):
            binary = plaintextBytes[col * 4 + row]
            state[row, col] = int(binary, 2)
    print("The initial state:\n{}\n".format(state))
    return state


def MidoriEncrypt(plaintext, key):
    """
    Performs Midori 128 bit encryption
    :param plaintext:   the plaintext (as binary)
    :param key: the key (as binary)
    :return: The ciphertext (as hex)
    """
    plaintext = plaintext[2:].zfill(128)  # Remove the binary prefix in the binary strings, and pad with zeros
    key = key[2:].zfill(128)
    r = 20  # Number of rounds
    state = InitializeState(plaintext)
    state = KeyAdd(state, key)
    print("Hex:\n{0:02x}\n".format(int(StateToBinary(state), 2)))
    RKs = RoundKeyGen(key)
    # This is where the magic happens
    for i in range(r - 1):
        state = SubCell(state)
        print("Hex state:\n{0:02x}\n".format(int(StateToBinary(state), 2)))
        state = ShuffleCell(state)
        print("Hex state:\n{0:02x}\n".format(int(StateToBinary(state), 2)))
        state = MixColumn(state)
        print("Hex state:\n{0:02x}\n".format(int(StateToBinary(state), 2)))
        state = KeyAdd(state, RKs[i])
        print("Hex state:\n{0:02x}\n".format(int(StateToBinary(state), 2)))
    state = SubCell(state)
    y = KeyAdd(state, key)
    ciphertext = int(StateToBinary(y), 2)
    print("The ciphertext is as follows:\n0x{0:02x}".format(ciphertext))
    return "0x{0:02x}".format(ciphertext)


def main():
    # Midori 128 implementation
    # Convert input, given as hex, to binary (padded with zeros)
    plaintext = bin(0x51084CE6E73A5CA2EC87D7BABC297543)
    key = bin(0x687DED3B3C85B3F35B1009863E2A8CBF)
    ciphertext = "0x1E0AC4FDDFF71B4C1801B73EE4AFC83D".lower()
    c = MidoriEncrypt(plaintext, key)
    if c != ciphertext:
        print("The ciphertexts were not the same.")
        print("Expected ciphertext:\t{}".format(ciphertext))
        print("Calculated ciphertext:\t{}".format(c))
    else:
        print("The ciphertexts were the same!")


if __name__ == "__main__":
    main()
