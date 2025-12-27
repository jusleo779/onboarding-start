<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The project is an SPI module that has multiple always statements that has clocks. The first always statement creates synchronization between the information/data, allowing for all the data to be the same between the different statements. The next always statement is the important section that actually makes it an SPI module. Firstly, there is the edge detection, which tells the chip when to increase the bit count of the data we are trying to save when the chip is selected. When the chip isn't selected then nothing happens and just resets all the values if the chip was partially done. When the chip gets all the data of 16 bits. It will then check which address it should go to and move into the right address through a case statement.

## How to test

Explain how to use your project.

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any.
