module top (
    input  wire clk,          // hlavní hodiny
    input  wire clk_sys,      // systémové hodiny
    input  wire btn_rst_n,    // resetovací tlačítko
    input  uart_rx,
    output [2:0] TMDSp, TMDSn,
    output TMDSp_clock, TMDSn_clock,
    output uart_tx ,
    output reg [5:0] led
);
    
//    shift_register uartRXSF(
//        .data_in(uart_rx),
//        .data_out(uart_rx_sync),
//        .clk(clk),
//        .reset(1'b0)
//    );
//    shift_register uartTXSF(
//        .data_in(uart_tx_sync),
//        .data_out(uart_tx),
//        .clk(clk),
//        .reset(1'b0)
//    );

    localparam CORDW = 16;       // šířka souřadnic (bitů)
    wire signed [CORDW-1:0] sx, sy;
    wire hsync, vsync;
    wire de, frame, line;

    // Generátor znaků, monochromatický, font 8x16
    wire [2:0] x_char = sx[2:0];
    wire [3:0] y_char = sy[3:0];

    // Výpočet horizontální a vertikální pozice buňky
    wire [6:0] charnum;
    wire [6:0] x_cell = sx[9:3];  // 80 cols
    wire [4:0] y_cell = sy[8:4];  // 30 rows
    wire [11:0] video_addr = {y_cell, x_cell};

    // Generování hodinového signálu
    wire clkout_o, lock_o;
    Gowin_rPLL dvi_rPLL(
        .clkout(clkout_o), //output clkout
        .lock(lock_o),     //output lock
        .clkin(clk)        //input clkin
    );

    // Generování synchronizačních signálů
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
reg [7:0] tx_data; // Data to be transmitted
reg tx_data_valid; // Valid signal for transmission data
wire tx_data_ready; // Ready signal for transmission data
reg [4:0] tx_cnt; // Counter for transmitted bytes
    localparam PROMPT_LEN = 21; // Length of the prompt message with escape sequences
    reg [7:0] prompt [PROMPT_LEN-1:0]; // Buffer to hold the prompt message
    reg [5:0] prompt_cnt; // Counter for prompt message
    reg [3:0] state;
    reg       false;




        // Připojení demo modulu
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
    state = 1'b0;
    false = 1'b0;
end




//    uart_rx rxmod(.clk(clk), .byteReady(byteReady), .dataIn(uartDataIn), .rx(uart_rx)); //rec
 //   uart_tx txmod(.clk(clk), .tx(uart_tx), .send(tx_data_valid), .data(tx_data), .busy(false)); //env
    
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
        .busy(false)
    ); // Transmitter module

    localparam bufferWidth = 640; 
    reg [(bufferWidth-1):0] UARTcharBuf = 0;
    reg [7:0] inputCharIndex = 0;


   //states
    
    localparam  IDDLE = 1'b0;
    localparam  SEND_PROMPT = 1'b1;
    localparam  SEND_COMMAND = 2'b10;
    localparam CLEAR_BUFFER = 2'b11;
    localparam ECHO = 3'b001;

integer i;
reg vga_text_dataFlag = 1'b0;

always @(posedge clk) begin
        if (byteReady) begin
            UARTcharBuf[(inputCharIndex*8) + 8] <= uartDataIn;
            inputCharIndex <= inputCharIndex + 1;
        end
        
        if (uartDataIn == 8'd13) begin // Enter key
            state <= SEND_COMMAND;
            led <= 6'b010101;
        end
    case (state)
        IDDLE : begin
            y_char_delayed <= y_char;
            x_char_delayed <= x_char;
            prompt_cnt <= 6'd0;
            led <= 6'b111111;
        end
            SEND_PROMPT: begin // SEND_PROMPT state
                if (tx_data_valid && tx_data_ready && prompt_cnt < PROMPT_LEN) begin // If data is valid, ready, and not the last byte of prompt
                    tx_data <= prompt[prompt_cnt]; // Load next byte of prompt
                    prompt_cnt <= prompt_cnt + 1; // Increment prompt counter
                end else if (tx_data_valid && tx_data_ready) begin // If last byte of prompt is sent
                    tx_data_valid <= 1'b0; // Set data valid to 0
                    state <= ECHO; // Move to ECHO state
                end else if (!tx_data_valid) begin // If data is not valid
                    tx_data_valid <= 1'b1; // Set data valid to 1
                    tx_data <= prompt[prompt_cnt]; // Load first byte of prompt
                end
            end
            ECHO: begin // ECHO state
                if (byteReady) begin // If valid data is received
                    if (uartDataIn == 8'h08) begin // If backspace key is pressed
        //                if (command_index > 0) begin // If buffer is not empty
//                            command_index <= command_index - 1; // Decrement command buffer index
  //                          tx_data <= 8'h08; // Echo backspace
    //                        tx_data_valid <= 1'b1; // Set data valid to 1
      //                  end
//end else if (rx_data == 8'h0d) begin // If Enter key is pressed
//state <= COPY_COMMAND; // Move to COPY_COMMAND state
  //                      copy_index <= 0; // Initialize copy index
                    end else begin
//                        tx_data <= rx_data; // Load received data to transmit
                        tx_data_valid <= 1'b1; // Set data valid to 1
 //                      internal_command_buffer[command_index] <= rx_//data; // Store received character in buffer
//                        command_index <= command_index + 1; // Increment command buffer index
 //                       command_ready <= 1'b0; // Reset command_ready
                    end
                end else if (tx_data_valid && tx_data_ready) begin // If data is valid and ready
                    tx_data_valid <= 1'b0; // Set data valid to 0
                end
            end
        SEND_COMMAND : begin
            vga_text_dataFlag <= 1'b1;
            state <= CLEAR_BUFFER;
        end
        CLEAR_BUFFER: begin
            for (i = 0; i < (bufferWidth-1); i = i + 1) begin
                UARTcharBuf[i] <= 8'b0;
            end
            vga_text_dataFlag <= 1'b0;
            state <= IDDLE;
        end
    endcase
end


    text_to_VGA text_to_VGA (
        .i_clk(vsync),
        .o_address(vram_addr),   // adresa videa pro zápis [12:0]
        .o_data(vram_data),      // znak k zápisu [7:0]
        .o_we(printable),        // znak k tisku
//        .full,
        .i_ena(1'b1),             // povolení modulu
        .i_data(uartDataIn)
//        .clean()
    );

    // 256 chars, 16 rows, 8 cols => 8+4+3 = 15 bits
    wire [14:0] rom_addr = {charnum, y_char_delayed, x_char_delayed};

    // Připojení duální paměti RAM
    charbuf charbuf(
        // A port: write
        .ada(vram_addr),   // input [12:0] A address
        .dina(vram_data),  // input [7:0]  Data in
        .clka(clk),        // input clock for A port
        .ocea(1'b1),       // input output clock enable for A
        .cea(printable),   // input clock enable for A
        .reseta(1'b0),     // input reset for A
        .wrea(printable),  // input write enable for A

        // B port: read
        .adb(video_addr),  // input [12:0] B address
        .doutb(charnum),   // output [7:0] Data out
        .clkb(clk),        // input clock for B port
        .oceb(1'b1),       // input output clock enable for B
        .ceb(1'b1),        // input clock enable for B
        .resetb(1'b0),     // input reset for B
        .wreb(1'b0),       // input write enable for B (not used)
        .dinb(8'h00)       // input data for B (not used)
    );

    // Připojení ROM paměti pro fonty
    Gowin_pROM font_rom(
        .dout(charbuf_o),        // output [0:0] dout
        .clk(clk),          // input clk
        .oce(1'b1),         // input oce
        .ce(1'b1),          // input ce
        .reset(1'b0),       // input reset
        .ad(rom_addr)       // input [14:0] ad
    );

    // Konverze výstupních dat na 8bitové RGB
    wire [7:0] paint_r = {8{charbuf_o}};
    wire [7:0] paint_g = {8{charbuf_o}};
    wire [7:0] paint_b = {8{charbuf_o}};

    // Výstup DVI
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
