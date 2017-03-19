import numpy as np
from math import floor
from constants import roundConstants


def SSbi(x, i):
    """
    Implements the Sbox within midori.
    :param x: The integer that is fed into the sbox
    :param i: Indicates which sbox must be used
    :return: A permuted x
    """
    # x0 is the most significant bit, x7 the least significant
    x0 = x & 128
    x1 = x & 64
    x2 = x & 32
    x3 = x & 16
    x4 = x & 8
    x5 = x & 4
    x6 = x & 2
    x7 = x & 1
    result = 0
    if i == 0:
        result = BitArrayToInt([x4, x1, x6, x3, x0, x5, x2, x7])
    elif i == 1:
        result = BitArrayToInt([x1, x6, x7, x0, x5, x2, x3, x4])
    elif i == 2:
        result = BitArrayToInt([x2, x3, x4, x1, x6, x7, x0, x5])
    elif i == 3:
        result = BitArrayToInt([x7, x4, x1, x2, x3, x0, x5, x6])
    return result


def BitArrayToInt(bitarray):
    """
    Converts a array of bits, where the first element is the most significant bit and the last element the least
    significant one, to the corresponding integer value.
    :param bitarray: The bitarray containing all of the bits
    :return: The integer value that corresponds to the binary representation of the bit array.
    """
    newNumber = 0
    for i in range(len(bitarray) - 1, -1, -1):
        if bitarray[i] > 0:
            newNumber |= 1 << (len(bitarray) - i - 1)
    return newNumber


def SubCell(state):
    """
    SSbi is applied 8-bit cell of the state S.
     Namely, si <=  SSb(i mod 4)[si] for Midori128, where 0 <= i <= 15.
    :param state: The state
    :return: A new state in which the permumtation is applied.
    """
    print("SubCell, original state:\n{}".format(state))
    for col in range(4):
        for row in range(4):
            si = state[row, col]
            state[row, col] = SSbi(si, (col * 4 + row) % 4)
            print("SubCell, new state:\n{}".format(state))
    return state


def ShuffleCell(state):
    """
    Each cell of the state is permuted as follows:
    (s0, s1,..., s15) <=  (s0, s10, s5, s15, s14, s4, s11, s1, s9, s3, s12, s6, s7, s13, s2, s8).
    :param state: The current state matrix S.
    :return: Permuted state matrix S
    """
    sDict = {}
    for col in range(4):
        for row in range(4):
            i = col * 4 + row
            sDict['s' + str(i)] = state[row, col]
    return np.matrix([
        [sDict['s0'], sDict['s14'], sDict['s9'], sDict['s7']],
        [sDict['s10'], sDict['s4'], sDict['s3'], sDict['s13']],
        [sDict['s5'], sDict['s11'], sDict['s12'], sDict['s2']],
        [sDict['s15'], sDict['s1'], sDict['s6'], sDict['s8']]
    ])


def MixColumn(state):
    """
    MixColumn (S): M is applied to every 4m-bit column of the state S, i.e.,
    (si; si+1; si+2; si+3)^T =  M * (si; si+1; si+2; si+3)^T and i = 0; 4; 8; 12.
    :param state: The current state matrix
    :param M: The involutive binary matrix
    :return: Updated state
    """
    M = np.matrix([
        [0, 1, 1, 1],
        [1, 0, 1, 1],
        [1, 1, 0, 1],
        [1, 1, 1, 0]
    ]
    )
    print(np.array(state[:, 0]))
    state[:, 0] = M.dot(state[:, 0]) % 256
    state[:, 1] = M.dot(state[:, 1]) % 256
    state[:, 2] = M.dot(state[:, 2]) % 256
    state[:, 3] = M.dot(state[:, 3]) % 256
    print("MixColumn result:\n{}".format(state))
    return state


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
    roundKey = key
    for r in range(19):
        rConst = roundConstants[r]
        curRoundKeyBytes = SplitByN(roundKey, 8)  # Split current round key into an array of bytes
        newRoundKeyBytes = []
        for i in range(16):
            # loop through round constant array and XOR with LSB bit of current byte of key
            # Calculate the 2d index from the 1d index
            col = floor(i / 4)
            row = i % 4
            bit = rConst[row, col]  # Take the value from the round constant to XOR with
            curRoundKeyByte = curRoundKeyBytes[i]
            newRoundKeyByte = bin(int(curRoundKeyByte, 2) ^ bit)[2:].zfill(
                8)  # Perform the XOR with the LSB of the current byte
            newRoundKeyBytes.append(newRoundKeyByte)
        roundKey = ''.join(newRoundKeyBytes)  # Reconstruct round key
        roundKeys.append(roundKey)
    return roundKeys


def KeyAdd(stateS, roundKeyI):
    """
    The i-th n-bit round key RKi is XORed to a state S.
    :param stateS: state S
    :param roundKeyI: The ith round key
    :return: The new state S in which the round key is XORed with the state.
    """
    roundKeyBytesArray = SplitByN(roundKeyI, 8)
    for col in range(4):
        for row in range(4):
            si = stateS[row, col]
            roundKeyByte = int(roundKeyBytesArray[col * 4 + row], 2)
            stateS[row, col] = roundKeyByte ^ si
    return stateS


def InitializeState(binaryString):
    """
    Initializes the state with given binary string (which should be padded to a lenght of 128 bits.
    :param binaryString: The binary string
    :return: The state that corresponds to the given binary string.
    """
    S = np.zeros(shape=(4, 4), dtype=np.uint8)
    print(S)
    # Again, s0 contains the 8 most significant bits of the plaintext, and s15 the least significant ones
    plaintextBytes = SplitByN(binaryString, 8)
    for col in range(4):
        for row in range(4):
            binary = plaintextBytes[col * 4 + row]
            S[row, col] = int(binary, 2)
    print("The initial state is as follows:\n{}".format(S))
    return S


def MidoriEncrypt(plaintext, key):
    """
    Performs Midori 128 bit encryption
    :param plaintext:   the plaintext (as binary)
    :param key: the key (as binary)
    :return: The ciphertext (as hex)
    """
    plaintext = plaintext[2:].zfill(128)  # Remove the binary prefix in the binary strings, and pad with zeros
    key = key[2:].zfill(128)
    print("plaintext:\t{}\nkey:\t\t{}".format(plaintext, key))
    r = 20  # Number of rounds
    state = InitializeState(plaintext)
    state = KeyAdd(state, key)
    RKs = RoundKeyGen(key)
    # This is where the magic happens
    for i in range(r - 1):
        state = SubCell(state)
        state = ShuffleCell(state)
        state = MixColumn(state)
        state = KeyAdd(state, RKs[i])
    state = SubCell(state)
    y = KeyAdd(state, key)
    ciphertext = int(StateToBinary(y), 2)
    print("The ciphertext is as follows:\n0x{0:02x}".format(ciphertext))
    return "0x{0:02x}".format(ciphertext)


def main():
    # Midori 128 implementation
    # Convert input, given as hex, to binary (padded with zeros)
    plaintext = bin(0x51084ce6e73a5ca2ec87d7babc297543)
    key = bin(0x687ded3b3c85b3f35b1009863e2a8cbf)
    ciphertext = "0x1e0ac4fddff71b4c1801b73ee4afc83d"
    c = MidoriEncrypt(plaintext, key)
    if c != ciphertext:
        print("The ciphertexts were not the same.")
        print("Expected ciphertext:\t{}".format(ciphertext))
        print("Calculated ciphertext:\t{}".format(c))


if __name__ == "__main__":
    main()
