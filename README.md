# ARM Assembly
Course Assignments for CS 2400 and 3750  
Spring 2015 / Fall 2016  
Dr. Weiying Zhu  
Metropolitan State University of Denver  

## Configuration and Execution
1. These ARM programs are configured to run with the [Keil µVision v5 IDE](http://www2.keil.com/mdk5/). Before you begin, make sure that this application is properly installed and configured for your machine. [Note: you may wish to create a dedicated project directory before continuing.]

1. Within µVision, create a new project.

    1. Begin by selecting `Project` -> `New µVision project...` from the menu bar.
    1. Now navigate to the desired directory, select a name for your project, and click `OK`.
    1. In the `Select Device for Target...` window, expand `ARM` -> `ARM Cortex M3` and select `ARMCM3`. Click `OK`.
    1. In the `Manage Run-Time Environment...` window, select `CMSIS` -> `Core` and `Device` -> `Startup`. Click `OK`.

1. Now that you have a new project created, let's finish configuring it by adding the appropriate source files and enabling the simulator.

    1. Within the `Project` window, navigate to `Project: [project name]` -> `Target 1`. Right click on `Target 1` and select ``Options for Target `Target 1`...``. Within this new dialogue, click the `Debug` tab and select `Use Emulator`. Click `OK`.
    1. Within the `Project` window again, navigate to `Project: [project name]` -> `Target 1` -> `Source Group 1`. This is where you will add all relevant source files. To add a `.s` file, right click on `Source Group 1` and select ``Add Existing Files to Group `Source Group 1`... ``.

1. With the source code added and the emulator configured, the project is ready to be built and tested.

    1. Select `Project` -> `Build Project` from the menu bar. Any errors or warnings will appear in the `Build Output` window. [Note: if you wish to test the application with different inputs, make sure the appropriate changes are made to the source files before building the project.]

    1. With the project built, you can enter the debug environment by selecting `Debug` -> `Start/Stop Debug Sessions...` from the menu bar.

    1. You may execute the application within the debug environment by selecting `Run`, or partially execute the application by selecting `Step` or `Step Over`.

    1. Once the application has finished running, you can interact with the result by using the `Command` window to query for specific exported variables.

        * Some applications will export memory values instead of a literal output. For these applications, you will need to enter the memory value provided into the `Memory 1` window and configure the window to view the output data in the correct format. Notes for configuring the memory window can be found with each application below where applicable.

1. Now that you have run one application successfully, you can alter the source code used for the project by replacing the `.s` file  in the `Project: [project name]` -> `Target 1` -> `Source Group 1` directory. Alternatively, you can create an entire new project (optionally with it's own new directory) and follow steps 1-4 again. Both of these options allow for testing new or altered applications.

## Assignments
### 01 Hexadecimal Subtraction

This program converts two hexadecimal numbers into their appropriate two's complement and then subtracts the first operand from the second operand, storing the difference of "B-A" in memory.
#### Input
`A`: a hexadecimal value stored digit-by-digit. The default value is `A05E65`.  
`B`: a hexadecimal value stored digit-by-digit. The default value is `FA248B6E`.
#### Output
`Result`: stores the literal value of the difference "B-A". The expected result given default inputs is `F9842D09`.

### 02 String Combination

This program takes two strings and combines them a character at a time, storing the interlaced string in memory.
#### Input
`StrOne`: the first null-terminated string to be combined. The default value is `Hello World`.  
`StrTwo`: the second null-terminated string to be combined. The default value is `To be or not to be`.
#### Output
`ADDR_MixStr`: stores the **memory address** of the combined string. To view the string, enter this memory address into the `Memory 1` Window, then right click anywhere in the memory display and select `ASCII`. The expected result given default inputs is `HTeol lboe  Woorr nlodt to be`.

### 03 Hexadecimal to Decimal Conversion

This program takes a string representing a hexadecimal value in memory and converts it into a new string representing the equivalent decimal value with a unary negation if the value is negative.
#### Input
`HexStr`: the string representing a hexadecimal value. The default value is `3F0D5A`.
#### Output
`ADDR_DecStr`: stores the **memory address** of the resultant decimal value string. To view the string, enter this memory address into the `Memory 1` Window, then right click anywhere in the memory display and select `ASCII`. The expected result given the default input is `4132186`.

### 04 Hamming Error Correction

This program takes a string containing a binary hamming code and recovers the source word, correcting any errors that can be identified.
#### Input
`Code`: the string containing the hamming code encrypted message, potentially with errors. The default value is `111111000001101`.
#### Output
`ADDR_Source`: stores the **memory address** of the string containing the source word. To view the string, enter this memory address into the `Memory 1` Window, then right click anywhere in the memory display and select `ASCII`. The expected result given the default input is `11101001101`.

### 05 Valid Integer Accumulator

This program processes an array of signed, 32-bit integers and determines which values are within the range of [-100, 100]. The program produces as output the total number of values within the given range and the sum of all of those valid ints added together.
#### Input
`IntArray`: a contiguous array of up to 10 32-bit, signed integers. The default value in decimal is: `[50, -125, 465, 232, 101, 145, 54, 25, -20]`.
#### Output
`ADDR_Counter`: stores the **memory address** of the number of integers within the valid interval. To view the integer, enter this memory address into the `Memory 1` Window, then right click anywhere in the memory display and select `Signed` -> `Int`. Make sure the `Decimal` option is selected. The expected result given the default input in decimal is `5`.  
`ADDR_Sum`: stores the **memory address** of the total sum of all valid integers. To view the integer, enter this memory address into the `Memory 1` Window, then right click anywhere in the memory display and select `Signed` -> `Int`. Make sure the `Decimal` option is selected. The expected result given the default input in decimal is `109`.  

### 06 TEA Decryption

This program implements the decryption half of the [Tiny Encryption Algorithm (TEA)](https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm), taking as input two encrypted message values and producing the original source words.
#### Input
`LTwo`: the "left-side" encrypted message stored in hexadecimal. The default value is `B72599B2`.  
`RTwo`: the "right-side" encrypted message stored in hexadecimal. The default value is `CF8E5A4C`.
#### Output
`LZero`: the literal hexadecimal representation of the decrypted "left-side" source word. The expected result given the default input is `A0000006`.  
`RZero`: the literal hexadecimal representation of the decrypted "right-side" source word. The expected result given the default input is `8000006B`.  

### 07 TEA Encryption

This program implements the encryption half of the [Tiny Encryption Algorithm (TEA)](https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm), taking as input two source words and producing the two-part encrypted message.
#### Input
`LZero`: the "left-side" unencrypted source word stored in hexadecimal. The default value is `A0000006`.  
`RZero`: the "right-side" encrypted message stored in hexadecimal. The default value is `8000006B`.
#### Output
`LTwo`: the literal hexadecimal representation of the encrypted "left-side" coded message. The expected result given the default input is `B72599B2`.  
`RTwo`: the literal hexadecimal representation of the encrypted "right-side" coded message. The expected result given the default input is `CF8E5A4C`.  
