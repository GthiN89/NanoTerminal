module text_to_VGA (
    input i_clk,           // System clock input
    input reg i_ena,           // Enable signal input
    input clean,           // Clean/reset signal input
    input [7:0] i_data  [79:0], // Input data buffer (256 bytes)
    input  reg vga_text_dataFlag,
    output reg [95:0] o_address, // Output address for VGA memory
    output reg [7:0] o_data, // Output data for VGA memory
    output reg o_we, // Write enable signal for VGA memory
    output reg full,  // Output signal indicating full screen
    output reg  [7:0] i_data_buff [78:0] // Debug output for i_data_buff
);

//reg [7:0] i_data_buff [79:0];

reg i_ena_delay;
//reg i_data_delay;
reg i_text_buff = 0;

localparam maxcol = 79; // 80 columns (0 to 79)
localparam maxlin = 29; // 30 rows (0 to 29)

reg [80:0] idx = 0;  // Text index (from 0 to 255)
reg [12:0] col = 0;  // Horizontal position (from 0 to maxcol)
reg [35:0] lin = 0;  // Vertical position (from 0 to maxlin)

reg [4:0] counter = 0;        // Waiting timer counter
wire slowclock = counter[1];  // Derived slow clock

// State machine states
localparam STATE_INIT = 0; // State for initial message
localparam STATE_WAIT_CMD = 1; // State for waiting for user commands
localparam STATE_WRITE_TEXT = 2; // State for writing text
localparam STATE_SCREEN_FULL = 3; // State for screen full

reg [1:0] state = STATE_INIT; // State machine register
localparam OFFSET = 8'd32;

// Initial message to be displayed once
//localparam init_len = 79;
//localparam [init_len*8-1:0] init_text = "123456789a123456789b123456789c123456789d123456789e123456789f123456789g123456789";

reg [80:0] init_idx = 0; // Initial message index

// Wrap counters
//wire [8:0] next_lin = (lin == maxlin) ? 5'b0 : lin + 1'b1; // Next line counter
//wire [8:0] next_idx = (idx == 255) ? 7'b0 : idx + 1'b1; // Next index counter


reg done_flag = 1;
reg [8:0]i_text_buff_counter = 0;
always @(posedge i_clk or posedge i_ena) begin
  //  counter <= counter + 1'b1; // Increment the counter

    if (i_ena) begin
        i_text_buff <= 1;
    end else begin 
        i_text_buff <= 0;
    end
end

    localparam init_len = 79;
//

    initial begin
                           i_data_buff[0]  <= 8'd45;  // '-'
                    i_data_buff[1]  <= 8'd45;  // '-'
                    i_data_buff[2]  <= 8'd45;  // '-'
                    i_data_buff[3]  <= 8'd45;  // '-'
                    i_data_buff[4]  <= 8'd45;  // '-'
                    i_data_buff[5]  <= 8'd45;  // '-'
                    i_data_buff[6]  <= 8'd45;  // '-'
                    i_data_buff[7]  <= 8'd45;  // '-'
                    i_data_buff[8]  <= 8'd45;  // '-'
                    i_data_buff[9]  <= 8'd45;  // '-'
                    i_data_buff[10] <= 8'd45;  // '-'
                    i_data_buff[11] <= 8'd45;  // '-'
                    i_data_buff[12] <= 8'd45;  // '-'
                    i_data_buff[13] <= 8'd45;  // '-'
                    i_data_buff[14] <= 8'd45;  // '-'
                    i_data_buff[15] <= 8'd45;  // '-'
                    i_data_buff[16] <= 8'd45;  // '-'
                    i_data_buff[17] <= 8'd45;  // '-'
                    i_data_buff[18] <= 8'd45;  // '-'
                    i_data_buff[19] <= 8'd45;  // '-'
                    i_data_buff[20] <= 8'd45;  // '-'
                    i_data_buff[21] <= 8'd45;  // '-'
                    i_data_buff[22] <= 8'd45;  // '-'
                    i_data_buff[23] <= 8'd80;  // 'P'
                    i_data_buff[24] <= 8'd111; // 'o'
                    i_data_buff[25] <= 8'd119; // 'w'
                    i_data_buff[26] <= 8'd101; // 'e'
                    i_data_buff[27] <= 8'd114; // 'r'
                    i_data_buff[28] <= 8'd101; // 'e'
                    i_data_buff[29] <= 8'd100; // 'd'
                    i_data_buff[30] <= 8'd32;  // ' '
                    i_data_buff[31] <= 8'd66;  // 'B'
                    i_data_buff[32] <= 8'd121; // 'y'
                    i_data_buff[33] <= 8'd32;  // ' '
                    i_data_buff[34] <= 8'd66;  // 'B'
                    i_data_buff[35] <= 8'd101; // 'e'
                    i_data_buff[36] <= 8'd108; // 'l'
                    i_data_buff[37] <= 8'd111; // 'o'
                    i_data_buff[38] <= 8'd104; // 'h'
                    i_data_buff[39] <= 8'd111; // 'o'
                    i_data_buff[40] <= 8'd117; // 'u'
                    i_data_buff[41] <= 8'd98;  // 'b'
                    i_data_buff[42] <= 8'd101; // 'e'
                    i_data_buff[43] <= 8'd107; // 'k'
                    i_data_buff[44] <= 8'd45;  // '-'
                    i_data_buff[45] <= 8'd45;  // '-'
                    i_data_buff[46] <= 8'd45;  // '-'
                    i_data_buff[47] <= 8'd45;  // '-'
                    i_data_buff[48] <= 8'd45;  // '-'
                    i_data_buff[49] <= 8'd45;  // '-'
                    i_data_buff[50] <= 8'd45;  // '-'
                    i_data_buff[51] <= 8'd45;  // '-'
                    i_data_buff[52] <= 8'd45;  // '-'
                    i_data_buff[53] <= 8'd45;  // '-'
                    i_data_buff[54] <= 8'd45;  // '-'
                    i_data_buff[55] <= 8'd45;  // '-'
                    i_data_buff[56] <= 8'd45;  // '-'
                    i_data_buff[57] <= 8'd45;  // '-'
                    i_data_buff[58] <= 8'd45;  // '-'
                    i_data_buff[59] <= 8'd45;  // '-'
                    i_data_buff[60] <= 8'd45;  // '-'
                    i_data_buff[61] <= 8'd45;  // '-'
                    i_data_buff[62] <= 8'd45;  // '-'
                    i_data_buff[63] <= 8'd45;  // '-'
                    i_data_buff[64] <= 8'd45;  // '-'
                    i_data_buff[65] <= 8'd45;  // '-'
                    i_data_buff[66] <= 8'd45;  // '-'
                    i_data_buff[67] <= 8'd45;  // '-'
                    i_data_buff[68] <= 8'd45;  // '-'
                    i_data_buff[69] <= 8'd45;  // '-'
                    i_data_buff[70] <= 8'd45;  // '-'
                    i_data_buff[71] <= 8'd45;  // '-'
                    i_data_buff[72] <= 8'd45;  // '-'
                    i_data_buff[73] <= 8'd45;  // '-'
                    i_data_buff[74] <= 8'd45;  // '-'
                    i_data_buff[75] <= 8'd45;  // '-'
                    i_data_buff[76] <= 8'd45;  // '-'
                    i_data_buff[77] <= 8'd45;  // '-'
                    i_data_buff[78] <= 8'd45;  // '-'
    end

always @(negedge i_ena) begin
 
  // Convert received data to the corresponding ASCII value
                    i_data_buff[0] <= i_data[0] - 8'h41 + 8'd97;
                    i_data_buff[1] <= i_data[1] - 8'h41 + 8'd97;
                    i_data_buff[2] <= i_data[2] - 8'h41 + 8'd97;
                    i_data_buff[3] <= i_data[3] - 8'h41 + 8'd97;
                    i_data_buff[4] <= i_data[4] - 8'h41 + 8'd97;
                    i_data_buff[5] <= i_data[5] - 8'h41 + 8'd97;
                    i_data_buff[6] <= i_data[6] - 8'h41 + 8'd97;
                    i_data_buff[7] <= i_data[7] - 8'h41 + 8'd97;
                    i_data_buff[8] <= i_data[8] - 8'h41 + 8'd97;
                    i_data_buff[9] <= i_data[9] - 8'h41 + 8'd97;
                    i_data_buff[10] <= i_data[10] - 8'h41 + 8'd97;
                    i_data_buff[11] <= i_data[11] - 8'h41 + 8'd97;
                    i_data_buff[12] <= i_data[12] - 8'h41 + 8'd97;
                    i_data_buff[13] <= i_data[13] - 8'h41 + 8'd97;
                    i_data_buff[14] <= i_data[14] - 8'h41 + 8'd97;
                    i_data_buff[15] <= i_data[15] - 8'h41 + 8'd97;
                    i_data_buff[16] <= i_data[16] - 8'h41 + 8'd97;
                    i_data_buff[17] <= i_data[17] - 8'h41 + 8'd97;
                    i_data_buff[18] <= i_data[18] - 8'h41 + 8'd97;
                    i_data_buff[19] <= i_data[19] - 8'h41 + 8'd97;
                    i_data_buff[20] <= i_data[20] - 8'h41 + 8'd97;
                    i_data_buff[21] <= i_data[21] - 8'h41 + 8'd97;
                    i_data_buff[22] <= i_data[22] - 8'h41 + 8'd97;
                    i_data_buff[23] <= i_data[23] - 8'h41 + 8'd97;
                    i_data_buff[24] <= i_data[24] - 8'h41 + 8'd97;
                    i_data_buff[25] <= i_data[25] - 8'h41 + 8'd97;
                    i_data_buff[26] <= i_data[26] - 8'h41 + 8'd97;
                    i_data_buff[27] <= i_data[27] - 8'h41 + 8'd97;
                    i_data_buff[28] <= i_data[28] - 8'h41 + 8'd97;
                    i_data_buff[29] <= i_data[29] - 8'h41 + 8'd97;
                    i_data_buff[30] <= i_data[30] - 8'h41 + 8'd97;
                    i_data_buff[31] <= i_data[31] - 8'h41 + 8'd97;
                    i_data_buff[32] <= i_data[32] - 8'h41 + 8'd97;
                    i_data_buff[33] <= i_data[33] - 8'h41 + 8'd97;
                    i_data_buff[34] <= i_data[34] - 8'h41 + 8'd97;
                    i_data_buff[35] <= i_data[35] - 8'h41 + 8'd97;
                    i_data_buff[36] <= i_data[36] - 8'h41 + 8'd97;
                    i_data_buff[37] <= i_data[37] - 8'h41 + 8'd97;
                    i_data_buff[38] <= i_data[38] - 8'h41 + 8'd97;
                    i_data_buff[39] <= i_data[39] - 8'h41 + 8'd97;
                    i_data_buff[40] <= i_data[40] - 8'h41 + 8'd97;
                    i_data_buff[41] <= i_data[41] - 8'h41 + 8'd97;
                    i_data_buff[42] <= i_data[42] - 8'h41 + 8'd97;
                    i_data_buff[43] <= i_data[43] - 8'h41 + 8'd97;
                    i_data_buff[44] <= i_data[44] - 8'h41 + 8'd97;
                    i_data_buff[45] <= i_data[45] - 8'h41 + 8'd97;
                    i_data_buff[46] <= i_data[46] - 8'h41 + 8'd97;
                    i_data_buff[47] <= i_data[47] - 8'h41 + 8'd97;
                    i_data_buff[48] <= i_data[48] - 8'h41 + 8'd97;
                    i_data_buff[49] <= i_data[49] - 8'h41 + 8'd97;
                    i_data_buff[50] <= i_data[50] - 8'h41 + 8'd97;
                    i_data_buff[51] <= i_data[51] - 8'h41 + 8'd97;
                    i_data_buff[52] <= i_data[52] - 8'h41 + 8'd97;
                    i_data_buff[53] <= i_data[53] - 8'h41 + 8'd97;
                    i_data_buff[54] <= i_data[54] - 8'h41 + 8'd97;
                    i_data_buff[55] <= i_data[55] - 8'h41 + 8'd97;
                    i_data_buff[56] <= i_data[56] - 8'h41 + 8'd97;
                    i_data_buff[57] <= i_data[57] - 8'h41 + 8'd97;
                    i_data_buff[58] <= i_data[58] - 8'h41 + 8'd97;
                    i_data_buff[59] <= i_data[59] - 8'h41 + 8'd97;
                    i_data_buff[60] <= i_data[60] - 8'h41 + 8'd97;
                    i_data_buff[61] <= i_data[61] - 8'h41 + 8'd97;
                    i_data_buff[62] <= i_data[62] - 8'h41 + 8'd97;
                    i_data_buff[63] <= i_data[63] - 8'h41 + 8'd97;
                    i_data_buff[64] <= i_data[64] - 8'h41 + 8'd97;
                    i_data_buff[65] <= i_data[65] - 8'h41 + 8'd97;
                    i_data_buff[66] <= i_data[66] - 8'h41 + 8'd97;
                    i_data_buff[67] <= i_data[67] - 8'h41 + 8'd97;
                    i_data_buff[68] <= i_data[68] - 8'h41 + 8'd97;
                    i_data_buff[69] <= i_data[69] - 8'h41 + 8'd97;
                    i_data_buff[70] <= i_data[70] - 8'h41 + 8'd97;
                    i_data_buff[71] <= i_data[71] - 8'h41 + 8'd97;
                    i_data_buff[72] <= i_data[72] - 8'h41 + 8'd97;
                    i_data_buff[73] <= i_data[73] - 8'h41 + 8'd97;
                    i_data_buff[74] <= i_data[74] - 8'h41 + 8'd97;
                    i_data_buff[75] <= i_data[75] - 8'h41 + 8'd97;
                    i_data_buff[76] <= i_data[76] - 8'h41 + 8'd97;
                    i_data_buff[77] <= i_data[77] - 8'h41 + 8'd97;
                    i_data_buff[78] <= i_data[78] - 8'h41 + 8'd97;
 
end


    integer i;
always @(posedge i_clk) begin
    if (clean) begin // If clean signal is active
        col <= 0; // Reset column position
        lin <= 1'b0; // Reset line position
        idx <= 0; // Reset index position
        init_idx <= 0; // Reset initial message index
        state <= STATE_INIT; // Set state to initial message
        full <= 0; // Clear full signal
    end else begin
        case (state)
            STATE_INIT: begin // State for initial message
                o_address <= {lin, col}; // Set output address
                o_data <= i_data_buff[init_idx]; // Set output data
                o_we <= 1'b1; // Set write enable
                init_idx <= init_idx + 1; // Increment initial message index
 //                                       lin <= lin + 1; // Increment line position
                            col <= col + 1'b1; // Increment column position
                // Update screen position
                if (i_data_buff[init_idx] == 8'h0A) begin // If newline character is detected
                    col <= 0; // Reset column position
                    //lin <= lin + 1; // Increment line position
                end else begin
                    if (col == maxcol) begin // If end of column
                        col <= 0; // Reset column position
 //                       lin <= lin + 1; // Increment line position
                    end else begin
//                        col <= col + 1'b1; // Increment column position
                    end
                end

                if (init_idx == init_len) begin // If end of initial message
                    state <= STATE_WAIT_CMD; // Set state to wait for commands
                    init_idx <= 0; // Reset initial message index
                end
            end

            STATE_WAIT_CMD: begin // State for waiting for user commands
                o_we <= 1'b0; // Disable write enable
                if (i_text_buff) begin // If enable signal is active
                     // Manually unroll the loop to copy input data to buffer                  
                    state <= STATE_WRITE_TEXT; // Set state to write text
                end
            end

            STATE_WRITE_TEXT: begin // State for writing text
                if(idx < 79) begin
//                o_address <= {(lin + 1), (col[4:0] -1)}; // Set output address
                o_address <= {lin + 1, idx}; // Set output address
                o_data <= i_data_buff[idx]; // Set output data
                idx <= idx + 1'b1; // Increment column position
                o_we <= 1'b1; // Set write enable
                end else begin 
                done_flag <= 0;
                state <= STATE_WAIT_CMD;
                idx <= 1'b1; // Increment text index
                end

//                    if (col == maxcol) begin // If end of column
//                        col <= 0; // Reset column position
                        lin <= lin + 1; // Increment line position
//                    end else begin
//                        col <= col + 1'b1; // Increment column position
//                    end
                

//                 Check if we have reached the end of the screen
                if (lin == maxlin && col == maxcol) begin // If end of screen
                    state <= STATE_SCREEN_FULL; // Set state to screen full
                    full <= 1; // Set full signal
                end
            end

            STATE_SCREEN_FULL: begin // State for screen full
                full <= 1; // Set full signal
                col <= 0; // Reset column position
                lin <= 1; // Reset line position
                idx <= 0; // Reset index position
                state <= STATE_WAIT_CMD; // Set state to wait for commands
            end
        endcase
    end
end

endmodule
