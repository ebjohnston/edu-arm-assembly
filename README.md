# Arm Assembly
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

1. Now that you have a new project created, lets finish configuring it by adding the appropriate source files and configurations.

    1. Within the `Project` window, navigate to `Project: [project name]` -> `Target 1`. Right click on `Target 1` and select ``Options for Target `Target 1`...``. Within this new dialogue, click the `Debug` tab and select `Use Emulator`. Click `OK`.
    1. Within the `Project` window again, navigate to `Project: [project name]` -> `Target 1` -> `Source Group 1`. This is where you will add all relevant source files. To add a `.s` file, right click on `Source Group 1` and select ``Add Existing Files to Group `Source Group 1`... ``.

1. With the source code added and the emulator configured, the project is ready to be built and tested.

    1. Select `Project` -> `Build Project` from the menu bar. Any errors or warnings will appear in the `Build Output` window. [Note: if you wish to test the application with different inputs, make sure the appropriate changes are made to the source files before building the project.]

    1. With the project built, you can enter the debug environment by selecting `Debug` -> `Start/Stop Debug Sessions...` from the menu bar.

    1. You may execute the application within the debug environment by selecting `Run`, or partially execute the application by selecting `Step` or `Step Over`.

    1. Once the application has finished running, you can interact with the result by using the `Command` window to query for specific exported variables.

        * Some applications will export memory values instead of a literal output. For these applications, you will need to enter the memory value provided into the `Memory 1` window and configure the window to view the output data in the correct format. Notes for configuring the memory window can be found with each application below where applicable.

1. Now that you have run one application successfully, you can alter the source code and remove the current file in the `Project: [project name]` -> `Target 1` -> `Source Group 1` and replace it with another. Alternatively, you can create an entire new project (optionally with it's own new directory) and follow steps 1-4 again to test a new or altered application.

## Assignments
### 01 Hexadecimal Subtraction
[Description]
### 02 String Combination
[Description]
### 03 Hexadecimal to Decimal Conversion
[Description]
### 04 Hamming Error Correction
[Description]
### 05 Valid Integer Accumulator
[Description]
### 06 TEA Decryption
[Description]
### 07 TEA Encryption
[Description]
