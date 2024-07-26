module uart_top(
    input clk,           // System clock input
    input rst,           // System reset input
    input uart_rx,       // UART receive pin
    output uart_tx,      // UART transmit pin
    output reg [7:0] output_command, // Single character command output
    output reg command_ready, // Signal to indicate command is ready
    output reg [1:0] state // State output
);

parameter CLK_FRE  = 25; // Clock frequency in MHz
parameter UART_FRE = 115200; // UART baud rate
localparam PROMPT_LEN = 21; // Length of the prompt message with escape sequences

localparam IDLE = 0; // IDLE state definition
localparam SEND_PROMPT = 1; // SEND_PROMPT state definition
localparam ECHO = 2; // ECHO state definition
localparam OUTPUT_CHAR = 3; // OUTPUT_CHAR state definition

reg [7:0] tx_data; // Data to be transmitted
reg tx_data_valid; // Valid signal for transmission data
wire tx_data_ready; // Ready signal for transmission data
reg [4:0] tx_cnt; // Counter for transmitted bytes
reg [7:0] prompt [PROMPT_LEN-1:0]; // Buffer to hold the prompt message
reg [5:0] prompt_cnt; // Counter for prompt message
reg [7:0] internal_command_buffer [255:0]; // Buffer to hold the received command internally
reg [7:0] command_index; // Index for the command buffer

wire rst_n = !rst; // Active low reset signal

// Define the prompt message "NucleusSoC> " with escape sequences for red color
initial begin
    prompt[0]  = 8'h1B; prompt[1]  = 8'h5B; prompt[2]  = 8'h33; prompt[3]  = 8'h31; prompt[4]  = 8'h6D; // ESC[31m (red)
    prompt[5]  = "N";   prompt[6]  = "u";   prompt[7]  = "c";   prompt[8]  = "l";   prompt[9]  = "e";
    prompt[10] = "u";   prompt[11] = "s";   prompt[12] = "S";   prompt[13] = "o";   prompt[14] = "C";
    prompt[15] = 8'h1B; prompt[16] = 8'h5B; prompt[17] = 8'h30; prompt[18] = 8'h6D; // ESC[0m (reset)
    prompt[19] = ">";   prompt[20] = " ";
end

assign rx_data_ready = 1'b1; // Always ready to receive data

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tx_data <= 8'd0;
        tx_data_valid <= 1'b0;
        state <= IDLE;
        prompt_cnt <= 6'd0;
        command_index <= 8'd0;
        command_ready <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                state <= SEND_PROMPT;
            end
            SEND_PROMPT: begin
                if (prompt_cnt < PROMPT_LEN) begin
                    if (tx_data_ready) begin
                        tx_data <= prompt[prompt_cnt];
                        tx_data_valid <= 1'b1;
                        prompt_cnt <= prompt_cnt + 1;
                    end
                end else if (tx_data_ready) begin
                    tx_data_valid <= 1'b0;
                    state <= ECHO;
                end
            end
            ECHO: begin
                if (rx_data_valid) begin
                    if (rx_data == 8'h08) begin // Backspace
                        if (command_index > 0) begin
                            command_index <= command_index - 1;
                            tx_data <= 8'h08;
                            tx_data_valid <= 1'b1;
                        end
                    end else if (rx_data == 8'h0D) begin // Enter
                        state <= OUTPUT_CHAR;
                        tx_data_valid <= 1'b0;
                    end else begin
                        if (tx_data_ready) begin
                            tx_data <= rx_data;
                            tx_data_valid <= 1'b1;
                            internal_command_buffer[command_index] <= rx_data;
                            command_index <= command_index + 1;
                        end
                    end
                end else if (tx_data_valid && tx_data_ready) begin
                    tx_data_valid <= 1'b0;
                end
            end
            OUTPUT_CHAR: begin
                if (command_index > 0) begin
                    output_command <= internal_command_buffer[0]; // Only output the first character
                    command_ready <= 1'b1;
                    state <= SEND_PROMPT;
                    prompt_cnt <= 6'd0;
                    command_index <= 8'd0;
                end else begin
                    command_ready <= 1'b0;
                    state <= SEND_PROMPT;
                    prompt_cnt <= 6'd0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

// UART RX instance
wire [7:0] rx_data; // Received data
wire rx_data_valid; // Valid signal for received data
uart_rx #(
    .CLK_FRE(CLK_FRE), // Clock frequency parameter
    .BAUD_RATE(UART_FRE) // Baud rate parameter
) uart_rx_inst (
    .clk(clk), // System clock
    .rst_n(rst_n), // Active low reset
    .rx_data(rx_data), // Received data output
    .rx_data_valid(rx_data_valid), // Received data valid output
    .rx_data_ready(rx_data_ready), // Ready to receive data input
    .rx_pin(uart_rx) // UART receive pin input
);

// UART TX instance
uart_tx #(
    .CLK_FRE(CLK_FRE), // Clock frequency parameter
    .BAUD_RATE(UART_FRE) // Baud rate parameter
) uart_tx_inst (
    .clk(clk), // System clock
    .rst_n(rst_n), // Active low reset
    .tx_data(tx_data), // Transmit data input
    .tx_data_valid(tx_data_valid), // Transmit data valid input
    .tx_data_ready(tx_data_ready), // Transmit data ready output
    .tx_pin(uart_tx) // UART transmit pin output
);




endmodule