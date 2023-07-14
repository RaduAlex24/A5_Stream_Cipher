package ro.ase.ism.sap.tema2;

import java.nio.ByteBuffer;

public class A5 {

    // Get hex
    public static String getHex(byte[] byteArray) {
        String result = "";
        for (byte elem : byteArray) {
            result += String.format("%02x ", elem);
        }
        return result;
    }


    // Registries
    static byte[] lfsr1 = new byte[3];
    static byte[] lfsr2 = new byte[3];
    static byte[] lfsr3 = new byte[3];

    // Masks
    // LFSR 1
    static byte lfsr1Mask18 = 1 << 5;
    static byte lfsr1Mask17 = 1 << 6;
    static byte lfsr1Mask16 = (byte) (1 << 7);
    static byte lfsr1Mask13 = 1 << 2;
    static byte lfsr1ClockBitMask = (byte) (1 << 7);

    // LFSR 2
    static byte lfsr2Mask21 = 1 << 2;
    static byte lfsr2Mask20 = 1 << 3;
    static byte lfsr2ClockBitMask = 1 << 5;

    // LFSR 3
    static byte lfsr3Mask22 = 1 << 1;
    static byte lfsr3Mask21 = 1 << 2;
    static byte lfsr3Mask20 = 1 << 3;
    static byte lfsr3Mask7 = 1;
    static byte lfsr3ClockBitMask = 1 << 5;

    // Majority bit
    static byte majorityBit = 0;


    // LFSR XOR functions
    public static byte getXORbit1() {
        byte bit18 = (byte) (((lfsr1[2] & lfsr1Mask18) >> 5) & 1);
        byte bit17 = (byte) (((lfsr1[2] & lfsr1Mask17) >> 6) & 1);
        byte bit16 = (byte) (((lfsr1[2] & lfsr1Mask16) >> 7) & 1);
        byte bit13 = (byte) (((lfsr1[1] & lfsr1Mask13) >> 2) & 1);

        byte resultBit = (byte) (bit18 ^ bit17);
        resultBit = (byte) (resultBit ^ bit16);
        resultBit = (byte) (resultBit ^ bit13);

        return resultBit;
    }

    public static byte getXORbit2() {
        byte bit21 = (byte) (((lfsr2[2] & lfsr2Mask21) >> 2) & 1);
        byte bit20 = (byte) (((lfsr2[2] & lfsr2Mask20) >> 3) & 1);

        byte resultBit = (byte) (bit21 ^ bit20);
        return resultBit;
    }

    public static byte getXORbit3() {
        byte bit22 = (byte) (((lfsr3[2] & lfsr3Mask22) >> 1) & 1);
        byte bit21 = (byte) (((lfsr3[2] & lfsr3Mask21) >> 2) & 1);
        byte bit20 = (byte) (((lfsr3[2] & lfsr3Mask20) >> 3) & 1);
        byte bit7 = (byte) (lfsr3[0] & lfsr3Mask7);

        byte resultBit = (byte) (bit22 ^ bit21);
        resultBit = (byte) (resultBit ^ bit20);
        resultBit = (byte) (resultBit ^ bit7);

        return resultBit;
    }


    // Shifting registers
    private static byte shiftRegister1(byte nextbit) {
        byte resultBit = (byte) (((lfsr1[2] & lfsr1Mask18) >> 5) & 1);

        // Saving bits
        byte bit0 = (byte) (lfsr1[0] & 1);
        byte bit1 = (byte) (lfsr1[1] & 1);

        // Shifting
        lfsr1[0] = (byte) (((lfsr1[0] >> 1) & 0b01111111) | (nextbit << 7));
        lfsr1[1] = (byte) (((lfsr1[1] >> 1) & 0b01111111) | (bit0 << 7));
        lfsr1[2] = (byte) ((((lfsr1[2] >> 1) & 0b01111111) | (bit1 << 7)) & 0b11100000);

        return resultBit;
    }

    private static byte shiftRegister2(byte nextbit) {
        byte resultBit = (byte) (((lfsr2[2] & lfsr2Mask21) >> 2) & 1);

        // Saving bits
        byte bit0 = (byte) (lfsr2[0] & 1);
        byte bit1 = (byte) (lfsr2[1] & 1);

        // Shifting
        lfsr2[0] = (byte) (((lfsr2[0] >> 1) & 0b01111111) | (nextbit << 7));
        lfsr2[1] = (byte) (((lfsr2[1] >> 1) & 0b01111111) | (bit0 << 7));
        lfsr2[2] = (byte) ((((lfsr2[2] >> 1) & 0b01111111) | (bit1 << 7)) & 0b11111100);

        return resultBit;
    }

    private static byte shiftRegister3(byte nextbit) {
        byte resultBit = (byte) (((lfsr3[2] & lfsr3Mask22) >> 1) & 1);

        // Saving bits
        byte bit0 = (byte) (lfsr3[0] & 1);
        byte bit1 = (byte) (lfsr3[1] & 1);

        // Shifting
        lfsr3[0] = (byte) (((lfsr3[0] >> 1) & 0b01111111) | (nextbit << 7));
        lfsr3[1] = (byte) (((lfsr3[1] >> 1) & 0b01111111) | (bit0 << 7));
        lfsr3[2] = (byte) ((((lfsr3[2] >> 1) & 0b01111111) | (bit1 << 7)) & 0b11111110);

        return resultBit;
    }


    // Setting the registries to 0
    public static void setRegistryTo0(byte[] registry) {
        for (int i = 0; i < registry.length; i++) {
            registry[i] = 0;
        }
    }


    // Majority bit
    public static void getMajorityBit() {
        int[] freqVect = new int[2];
        freqVect[0] = freqVect[1] = 0;

        // Clock bit 1
        byte clockBit1 = (byte) (((lfsr1[1] & lfsr1ClockBitMask) >> 7) & 1);

        // Clock bit 2
        byte clockBit2 = (byte) (((lfsr2[1] & lfsr2ClockBitMask) >> 5) & 1);

        // Clock bit 3
        byte clockBit3 = (byte) (((lfsr3[1] & lfsr3ClockBitMask) >> 5) & 1);

        // Determine majority bit
        freqVect[clockBit1]++;
        freqVect[clockBit2]++;
        freqVect[clockBit3]++;

        if (freqVect[0] > freqVect[1]) {
            majorityBit = 0;
        } else {
            majorityBit = 1;
        }
    }


    // Registries initialization
    public static void registryInitialization(String password) {
        byte[] sessionKey = password.getBytes();

        for (int i = 0; i < password.length(); i++) {
            for (int j = 7; j >= 0; j--) {
                // Password bite
                byte passwordBite = (byte) ((sessionKey[i] >> j) & 1);

                // lfsr 1
                byte nextBit1 = getXORbit1();
                nextBit1 = (byte) (nextBit1 ^ passwordBite);
                shiftRegister1(nextBit1);

                // lfsr 2
                byte nextBit2 = getXORbit2();
                nextBit2 = (byte) (nextBit2 ^ passwordBite);
                shiftRegister2(nextBit2);

                // lfsr 3
                byte nextBit3 = getXORbit3();
                nextBit3 = (byte) (nextBit3 ^ passwordBite);
                shiftRegister3(nextBit3);
            }
        }
        
        //System.out.println("Test");
    }


    // Frame counter
    public static void frameCounter(byte[] frame) {
        for (int i = 0; i < frame.length; i++) {
            for (int j = 7; j >= 0; j--) {
                // Getting the bit from the frame
                byte frameBit = (byte) ((frame[i] >> j) & 1);

                // lfsr 1
                byte nextBit1 = getXORbit1();
                nextBit1 = (byte) (nextBit1 ^ frameBit);
                shiftRegister1(nextBit1);

                // lfsr 2
                byte nextBit2 = getXORbit2();
                nextBit2 = (byte) (nextBit2 ^ frameBit);
                shiftRegister2(nextBit2);

                // lfsr 1
                byte nextBit3 = getXORbit3();
                nextBit3 = (byte) (nextBit3 ^ frameBit);
                shiftRegister3(nextBit3);
            }
        }

        //System.out.println("Test");
    }


    // Cycle 100 times with clocks
    public static void cycle100times() {
        for (int i = 0; i < 100; i++) {
            // Majority bit
            getMajorityBit();

            // Clocking bits
            // Clock bit 1
            byte clockBit1 = (byte) (((lfsr1[1] & lfsr1ClockBitMask) >> 7) & 1);
            // Clock bit 2
            byte clockBit2 = (byte) (((lfsr2[1] & lfsr2ClockBitMask) >> 5) & 1);
            // Clock bit 3
            byte clockBit3 = (byte) (((lfsr3[1] & lfsr3ClockBitMask) >> 5) & 1);


            // Clocking the registries
            if (clockBit1 == majorityBit) {
                byte nextBit1 = getXORbit1();
                shiftRegister1(nextBit1);
            }

            if (clockBit2 == majorityBit) {
                byte nextBit2 = getXORbit2();
                shiftRegister2(nextBit2);
            }

            if (clockBit3 == majorityBit) {
                byte nextBit3 = getXORbit3();
                shiftRegister3(nextBit3);
            }


        }

        //System.out.println("Test");
    }


    // Generating pseudorandom number
    public static void generatingNumber(byte[] result) {
        for (int i = 0; i < result.length; i++) {
            byte resultByte = 0;

            for (int j = 0; j < 8; j++) {
                // Majority bit
                getMajorityBit();

                // Clocking bits
                // Clock bit 1
                byte clockBit1 = (byte) (((lfsr1[1] & lfsr1ClockBitMask) >> 7) & 1);
                // Clock bit 2
                byte clockBit2 = (byte) (((lfsr2[1] & lfsr2ClockBitMask) >> 5) & 1);
                // Clock bit 3
                byte clockBit3 = (byte) (((lfsr3[1] & lfsr3ClockBitMask) >> 5) & 1);


                // Result bits
                byte resultBite1 = (byte) (((lfsr1[2] & lfsr1Mask18) >> 5) & 1);
                byte resultBite2 = (byte) (((lfsr2[2] & lfsr2Mask21) >> 2) & 1);
                byte resultBite3 = (byte) (((lfsr3[2] & lfsr3Mask22) >> 1) & 1);
                byte resultBite = (byte) (resultBite1 ^ resultBite2 ^ resultBite3);

                // Saveing result bite
                resultByte = (byte) (resultByte | resultBite);
                if (j != 7) {
                    resultByte = (byte) (resultByte << 1);
                }


                // Clocking the registries
                if (clockBit1 == majorityBit) {
                    byte nextBit1 = getXORbit1();
                    shiftRegister1(nextBit1);
                }

                if (clockBit2 == majorityBit) {
                    byte nextBit2 = getXORbit2();
                    shiftRegister2(nextBit2);
                }

                if (clockBit3 == majorityBit) {
                    byte nextBit3 = getXORbit3();
                    shiftRegister3(nextBit3);
                }

                //System.out.println("Test");
            }

            result[i] = resultByte;
        }

    }


    // A5 generator
    public static byte[] A5Generator(String password, byte[] frame, int sequenceNoBytes) {
        byte[] result = new byte[sequenceNoBytes];

        // Setting registry to 0
        setRegistryTo0(lfsr1);
        setRegistryTo0(lfsr2);
        setRegistryTo0(lfsr3);

        // Initialization of registries with the password
        registryInitialization(password);

        // Adding the frame counter
        frameCounter(frame);

        // Cycle 100 times with clocks
        cycle100times();

        // Generating pseudorandom number
        generatingNumber(result);

        return result;
    }


    public static int[] fromByteToInt(byte[] byteArray) throws Exception {
        if (byteArray.length % 4 == 0) {
            int[] result = new int[byteArray.length / 4];
            int j = 0;
            ByteBuffer byteBuffer;

            for (int i = 0; i < byteArray.length; i += 4) {
                byteBuffer = ByteBuffer.wrap(byteArray, i, 4);
                int intValue = byteBuffer.getInt();
                result[j] = intValue;
                j++;
            }

            return result;
        } else {
            throw new Exception("Bad byte array size!");
        }
    }


    // Print int array
    public static void printIntArray(int[] intArray) {
        for (int intValue : intArray) {
            System.out.print(intValue + " ");
        }
        System.out.println();
    }


    // Main
    public static void main(String[] args) {
        String password = "password";
        byte[] frame = {(byte) 0xF0, 0x32, 0x11, 0x0F};


        byte[] result1 = A5Generator(password, frame, 8);
        System.out.println(getHex(result1));

        try {
            int[] intResult1 = fromByteToInt(result1);
            printIntArray(intResult1);
        } catch (Exception exception) {
            System.out.println("Exception: " + exception.getMessage());
        }


        byte[] result2 = A5Generator(password, frame, 256);
        System.out.println(getHex(result2));

        try {
            int[] intResult2 = fromByteToInt(result2);
            printIntArray(intResult2);
        } catch (Exception exception) {
            System.out.println("Exception: " + exception.getMessage());
        }

    }

}
