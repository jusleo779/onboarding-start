module spi_peripheral(
   //SPI interface
   input wire COPI,  //controller output peripheral in (data)
   input wire nCS, // chip select (active low = allow the chip to do something)
   input wire SCLK, //serial clock
   
   input wire rst_n,
   
   input wire clk, //clock for the posedge

   //SPI register Map
   output reg[7:0] en_reg_out_7_0, //reset value 0x00 (enable outputs)
   output reg[7:0] en_reg_out_15_8, //reset value 0x00 (enable outputs)
   output reg[7:0] en_reg_pwm_7_0, //reset value 0x00(enables PWM)
   output reg[7:0] en_reg_pwm_15_8, //reset value 0x00 (enables PWM)
   output reg[7:0] pwm_duty_cycle  //reset value 0x00 (PWM duty cycle)
);

//synchronization

//sync 1
reg sync_COPI;
reg sync_nCS;
reg sync_SCLK;

//sync 2
reg synced_COPI;
reg synced_nCS;
reg synced_SCLK;


always@(posedge clk)begin 
    //syncing SCLK
    sync_SCLK <= SCLK;
    synced_SCLK <= sync_SCLK;

    //syncing COPI
    sync_COPI <= COPI;
    synced_COPI <= sync_COPI;

    //syncing nCS
    sync_nCS <= nCS;
    synced_nCS <= sync_nCS;
end

wire sclk_sync = synced_SCLK;
wire copi_sync = synced_COPI;
wire nCS_sync  = synced_nCS;

//edge detection logic

reg prev;
wire rising_edge = ~prev & sclk_sync;
always @(posedge clk)begin
    prev <= sclk_sync;
end

reg [4:0] bit_count;
reg [15:0] shift_reg;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        bit_count <= 4'b0;
        shift_reg <= 8'b0;  
    end
    //when chip is not selected anymore then reset everything
    else if(nCS_sync)begin 
        bit_count <= 4'b0;
        shift_reg <= 8'b0;  
    end else begin

        //shifts the bits to the end
        if(rising_edge)begin
            shift_reg <= {shift_reg[14:0], copi_sync};
            bit_count <= bit_count + 1;
        end
    end
end

//shifting the bits into the right address
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        en_reg_out_15_8 <= 8'h0;
        en_reg_out_7_0 <= 8'h0;
        en_reg_pwm_15_8 <= 8'h0;
        en_reg_pwm_7_0 <= 8'h0;
        pwm_duty_cycle <= 8'h0;
    end
    else begin
        if(bit_count == 15 && shift_reg[15] == 1'b1 && rising_edge)begin 
            case(shift_reg[14:8])
                7'h0: en_reg_out_7_0 <= shift_reg[7:0];
                7'h1: en_reg_out_15_8 <= shift_reg[7:0];
                7'h2: en_reg_pwm_7_0 <= shift_reg[7:0];
                7'h3: en_reg_pwm_15_8 <= shift_reg[7:0];
                7'h4: pwm_duty_cycle <= shift_reg[7:0];
                default: ;//empty if there is no correct addresses
            endcase
        end  
    end
end
endmodule
