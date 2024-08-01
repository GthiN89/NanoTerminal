/*
    mcu_spi.v

    SPI interface for MCU with proper keyboard activation handling
*/

module mcu_spi (
  input        clk,             // Clock input
  input        reset,           // Reset signal

  // SPI interface to MCU
  input        spi_io_ss,       // SPI Slave Select
  input        spi_io_clk,      // SPI Clock
  input        spi_io_din,      // SPI Data Input
  output reg   spi_io_dout,     // SPI Data Output

  // Data output to MCU
  output       mcu_start,       // Indicates start of communication
  output reg   kbd_activate,    // Signal to activate keyboard interface
  input  [7:0] mcu_hid_din,     // Data input from HID
  output reg [7:0] mcu_dout,     // Data output to MCU
  output reg [5:0] kb_counter
);

// SPI mode 1: data is setup on rising, read on falling clock edge
reg [3:0] spi_cnt;              // Bit/byte counter
reg [7:0] spi_data_in;          // Latched data from SPI
reg [6:0] spi_sr_in;            // Shift register for incoming SPI data
reg spi_data_in_ready;          // Data ready flag

// Read data on falling edge of SPI clock
always @(negedge spi_io_clk or posedge spi_io_ss) begin
    if(spi_io_ss) begin
        spi_cnt <= 4'd0;        // Reset counter when SS is high
    end else begin
        spi_cnt <= spi_cnt + 4'd1; // Increment counter
        spi_sr_in <= { spi_sr_in[5:0], spi_io_din }; // Shift in new bit

        if(spi_cnt[2:0] == 3'd7) begin
            spi_data_in <= { spi_sr_in, spi_io_din }; // Latch byte
            spi_data_in_ready <= 1'b1; // Set data ready flag
        end

        if(spi_cnt[2:0] == 3'd3)
            spi_data_in_ready <= 1'b0; // Clear data ready flag
    end
end

// Transfer received byte to local clock domain
reg [1:0] spi_data_in_readyD;  // Delayed data ready signal
reg [7:0] spi_in_data;         // Data for internal processing
assign mcu_start = spi_cnt == 4'd2; // Start signal after 2 bytes
assign mcu_dout = spi_in_data; // Data output

always @(posedge clk or posedge reset) begin
    if (reset) begin
        spi_data_in_readyD <= 2'b00;
        kbd_activate <= 1'b0;
    end else begin
        spi_data_in_readyD <= { spi_data_in_readyD[0], spi_data_in_ready }; // Delay line

        if(spi_io_ss)
            spi_in_data <= 4'd0;    // Reset on SS

        if(spi_data_in_readyD == 2'b01) begin
            spi_in_data <= spi_data_in; // Capture incoming data

            // Activate keyboard interface when new byte is received
            kbd_activate <= 1'b1; // Set activate signal
            kb_counter <= kb_counter + 1;
        end else begin
            kbd_activate <= 1'b0; // Reset activate signal
        end
    end
end
reg [5:0] kb_counter;
// Setup data on rising edge of SPI clock
always @(posedge spi_io_clk or posedge spi_io_ss) begin
    if(spi_io_ss) begin
        spi_io_dout <= 1'b0; // Default output on SS high
    end else begin
       spi_io_dout <= mcu_hid_din[~spi_cnt[2:0]]; // Output data to SPI
    end
end

endmodule // mcu_spi
