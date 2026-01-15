<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The SPI module captures 16-bit transactions from a controller using synchronized flip-flops to prevent metastability. Data is sampled on the rising edge of SCLK, while a bit counter tracks how many bits have been received. Transactions are only processed when the chip is selected (nCS low); partial data is cleared if the chip is deselected before completion. Once a full 16-bit transaction is received, the module decodes the address from the data and writes the data to the corresponding register if writing is allowed, ensuring reliable and accurate SPI-controlled updates to the outputs.

## How to test

The project is tested using Cocotb test benches, focusing on verifying the PWM module’s frequency and duty cycle. A pre-made helper function, send_spi_transaction, is used to initiate SPI transactions and write data to the PWM registers.

To measure the PWM signals, I implemented rising edge detection and falling edge detection modules. These compare the current signal value with the previous value to detect edges. By recording the times of rising and falling edges, the testbench calculates the time period of the PWM signal, which is then used to compute the frequency and duty cycle. This approach ensures accurate verification of the PWM behavior for different duty cycle values and output configurations

## External hardware

No external hardware was used in this project
