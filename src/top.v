module top (
    input  wire clk,          // main clock
    input  wire clk_sys,      // system clock
    input  wire btn_rst_n,    // reset button
    input  wire uart_rx,      // UART receive
    output wire [2:0] TMDSp, TMDSn, // HDMI/DVI signals
    output wire TMDSp_clock, TMDSn_clock, // HDMI/DVI clock signals
    output wire uart_tx,      // UART transmit
    output reg [5:0] led      // LEDs
);

    localparam CORDW = 16;       // coordinate width (bits)
    wire signed [CORDW-1:0] sx, sy;
    wire hsync, vsync;
    wire de, frame, line;

    // Character generator, monochrome, font 8x16
    wire [2:0] x_char = sx[2:0];
    wire [3:0] y_char = sy[3:0];

    // Calculate horizontal and vertical cell positions
    wire [6:0] charnum;
    wire [6:0] x_cell = sx[9:3];  // 80 cols
    wire [4:0] y_cell = sy[8:4];  // 30 rows
    wire [11:0] video_addr = {y_cell, x_cell};

    // Clock generation
    wire clkout_o, lock_o;
    Gowin_rPLL dvi_rPLL(
        .clkout(clkout_o), //output clkout
        .lock(lock_o),     //output lock
        .clkin(clk)        //input clkin
    );

    // Display synchronization signals
    display_480p display_inst (
        .clk_pix(clk),
        .rst_pix(1'b0),
        .sx(sx),
        .sy(sy),
        .hsync(hsync),
        .vsync(vsync),
        .de(de),
        .frame(frame),
        .line()
    );

    // UART Communication
    reg [7:0] tx_data; // Data to be transmitted
    reg tx_data_valid; // Valid signal for transmission data
    wire tx_data_ready; // Ready signal for transmission data
    reg [4:0] tx_cnt; // Counter for transmitted bytes

    localparam PROMPT_LEN = 21; // Length of the prompt message with escape sequences
    reg [7:0] prompt [PROMPT_LEN-1:0]; // Buffer to hold the prompt message
    reg [6:0] prompt_cnt; // Counter for prompt message
    reg [3:0] state;
    reg       false;

    // VRAM and display signals
    wire [12:0] vram_addr;
    wire [7:0] vram_data;
    wire printable;
    reg [3:0] y_char_delayed;
    reg [2:0] x_char_delayed;

    initial begin
        prompt[0]  = 8'h1B; prompt[1]  = 8'h5B; prompt[2]  = 8'h33; prompt[3]  = 8'h31; prompt[4]  = 8'h6D; // ESC[31m (red)
        prompt[5]  = "N";   prompt[6]  = "u";   prompt[7]  = "c";   prompt[8]  = "l";   prompt[9]  = "e";
        prompt[10] = "u";   prompt[11] = "s";   prompt[12] = "S";   prompt[13] = "o";   prompt[14] = "C";
        prompt[15] = 8'h1B; prompt[16] = 8'h5B; prompt[17] = 8'h30; prompt[18] = 8'h6D; // ESC[0m (reset)
        prompt[19] = ">";   prompt[20] = " ";
        state = IDLE;
        false = 1'b0;
    end

    reg [7:0] uartDataIn;

    uart_rx rxmod(
        .clk(clk),
        .byteReady(byteReady),
        .dataIn(uartDataIn),
        .rx(uart_rx)
    ); // Receiver module

    uart_tx txmod(
        .clk(clk),
        .tx(uart_tx),
        .send(tx_data_valid),
        .data(tx_data),
        .busy()
    ); // Transmitter module

    localparam bufferWidth = 80; // chars 
    reg [8:0] UARTcharBuf [bufferWidth-1:0];
    reg [8:0] VGAcharBuf [bufferWidth-1:0];
    reg [8:0] inputCharIndex = 0;

    // States
    localparam  IDLE = 4'b0000;
    localparam  SEND_PROMPT = 4'b0001;
    localparam  RECEIVE_CHAR = 4'b0010;
    localparam  SEND_COMMAND = 4'b0011;
    localparam  CLEAR_BUFFER = 4'b0100;
    localparam  ECHO = 4'b0101;

    integer i;
    reg vga_text_dataFlag = 1'b0;
reg clear_delay = 0; // To store the previous state of uart_rx

    always @(posedge clk) begin

        case (state)
            IDLE: begin
            y_char_delayed <= y_char;
            x_char_delayed <= x_char;
            prompt_cnt <= 6'd0;
            led <= 6'b111000; // LED status for IDLE state
           for (i = 0; i < bufferWidth; i = i + 1) begin
                    VGAcharBuf[i] <= 8'b00000000;
                end
                    state <= SEND_PROMPT;
                
            end

            SEND_PROMPT: begin
                y_char_delayed <= y_char;
                x_char_delayed <= x_char;
                led <= 6'b000001; // LED status for SEND_PROMPT state
                if (prompt_cnt < PROMPT_LEN) begin
                    tx_data <= prompt[prompt_cnt]; // Load next byte of prompt
                    tx_data_valid <= 1'b1; // Trigger send
                    prompt_cnt <= prompt_cnt + 1; // Increment prompt counter
                end else begin
                    tx_data_valid <= 1'b0; // Stop sending
                    state <= RECEIVE_CHAR;
                end
            end

            RECEIVE_CHAR: begin
                y_char_delayed <= y_char;
                x_char_delayed <= x_char;
                led <= 6'b110011; // LED status for RECEIVE_CHAR state
                if (byteReady) begin
                    UARTcharBuf[inputCharIndex] <= uartDataIn;
                    inputCharIndex <= inputCharIndex + 1;
                    if (uartDataIn == 8'h8D) begin // Enter key
                      state <= SEND_COMMAND;
                    end
                end
            end

            SEND_COMMAND: begin
                vga_text_dataFlag <= 1'b1; // Set flag to 1 when sending data
                y_char_delayed <= y_char;
                x_char_delayed <= x_char;
                led <= 6'b001100; // LED status for SEND_COMMAND state
                VGAcharBuf <= UARTcharBuf;
                state <= CLEAR_BUFFER;

            end

            CLEAR_BUFFER: begin
                vga_text_dataFlag <= 1'b0; // Set flag to 1 when sending data
                y_char_delayed <= y_char;
                x_char_delayed <= x_char;
                led <= 6'b000000; // LED status for CLEAR_BUFFER state
                if (clear_delay < 1) begin
                    clear_delay <= 1; end else
                begin
                for (i = 0; i < bufferWidth; i = i + 1) begin
    
                    UARTcharBuf[i] <= 8'b00000000;
//                    VGAcharBuf[i] <= 8'b00000000;
                end
                inputCharIndex <= 0;
                vga_text_dataFlag <= 1'b0; // Ensure flag is cleared after buffer is cleared
                state <= IDLE;
                end
            end
        endcase
        
        vga_text_dataFlag_temp <= vga_text_dataFlag;
        vga_text_dataFlag_delay <= vga_text_dataFlag_temp;
    end
    reg vga_text_dataFlag_delay, vga_text_dataFlag_temp;
    text_to_VGA text_to_VGA_inst (
        .i_clk(vsync),
        .o_address(vram_addr),   // Video address for write [12:0]
        .o_data(vram_data),      // Character to write [7:0]
        .o_we(printable),        // Write enable signal
        .i_ena(vga_text_dataFlag), // Module enable
        .vga_text_dataFlag(vga_text_dataFlag),
        .i_data(VGAcharBuf)
    );

    // ROM address for font
    wire [14:0] rom_addr = {charnum, y_char_delayed, x_char_delayed};





    charbuffer80x30 buff80x30(
        // Port A: write
        .ada(vram_addr),   // input [15:0] A address
        .dina(vram_data),  // input [7:0]  Data in
        .clka(clk),        // input clock for A port
        .ocea(1'b1),       // input output clock enable for A
        .cea(printable),   // input clock enable for A
        .reseta(btn_rst_n),     // input reset for A
        .wrea(printable),  // input write enable for A

        // Port B: read
        .adb(video_addr),  // input [15:0] B address
        .doutb(charnum),   // output [7:0] Data out
        .clkb(clk),        // input clock for B port
        .oceb(1'b1),       // input output clock enable for B
        .ceb(1'b1),        // input clock enable for B
        .resetb(btn_rst_n),     // input reset for B
        .wreb(1'b0),       // input write enable for B (not used)
        .dinb(8'h00)       // input data for B (not used)
    );

    Gowin_pROM font_rom(
        .dout(charbuf_o),  // output [0:0] dout
        .clk(clk),         // input clk
        .oce(1'b1),        // input oce
        .ce(1'b1),         // input ce
        .reset(btn_rst_n),      // input reset
        .ad(rom_addr)      // input [14:0] ad
    );

    // Convert output data to 8-bit RGB
    wire [7:0] paint_r = {8{charbuf_o}};
    wire [7:0] paint_g = {8{charbuf_o}};
    wire [7:0] paint_b = {8{charbuf_o}};

    // DVI Output
    DVI_TX_Top DVI_out(
        .I_rst_n(1'b1),       // input I_rst_n
        .I_serial_clk(clkout_o), // input I_serial_clk
        .I_rgb_clk(clk),      // input I_rgb_clk
        .I_rgb_vs(vsync),     // input I_rgb_vs
        .I_rgb_hs(hsync),     // input I_rgb_hs
        .I_rgb_de(de),        // input I_rgb_de
        .I_rgb_r(paint_r),    // input [7:0] I_rgb_r
        .I_rgb_g(paint_g),    // input [7:0] I_rgb_g
        .I_rgb_b(paint_b),    // input [7:0] I_rgb_b
        .O_tmds_clk_p(TMDSp_clock), // output O_tmds_clk_p
        .O_tmds_clk_n(TMDSn_clock), // output O_tmds_clk_n
        .O_tmds_data_p(TMDSp), // output [2:0] O_tmds_data_p
        .O_tmds_data_n(TMDSn)  // output [2:0] O tmds_data_n
    );

endmodule
