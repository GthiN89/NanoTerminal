module text_to_VGA (
    input i_clk,           // System clock input
    input i_ena,           // Enable signal input
    input clean,           // Clean/reset signal input
    input [7:0] i_data  [79:0], // Input data buffer (256 bytes)
    output reg [12:0] o_address, // Output address for VGA memory
    output reg [7:0] o_data, // Output data for VGA memory
    output reg o_we, // Write enable signal for VGA memory
    output reg full  // Output signal indicating full screen
);

localparam maxcol = 79; // 80 columns (0 to 79)
localparam maxlin = 29; // 30 rows (0 to 29)

reg [6:0] idx = 0;  // Text index (from 0 to 255)
reg [6:0] col = 0;  // Horizontal position (from 0 to maxcol)
reg [4:0] lin = 0;  // Vertical position (from 0 to maxlin)

reg [4:0] counter = 0;        // Waiting timer counter
wire slowclock = counter[1];  // Derived slow clock

// State machine states
localparam STATE_INIT = 0; // State for initial message
localparam STATE_WAIT_CMD = 1; // State for waiting for user commands
localparam STATE_WRITE_TEXT = 2; // State for writing text
localparam STATE_SCREEN_FULL = 3; // State for screen full

reg [1:0] state = STATE_INIT; // State machine register

// Initial message to be displayed once
localparam init_len = 32;
localparam [init_len*8-1:0] init_text = "Welcome to NucleusSoC terminal.";

reg [6:0] init_idx = 0; // Initial message index

// Wrap counters
wire [4:0] next_lin = (lin == maxlin) ? 5'b0 : lin + 1'b1; // Next line counter
wire [6:0] next_idx = (idx == 255) ? 7'b0 : idx + 1'b1; // Next index counter

always @(posedge i_clk) begin
    counter <= counter + 1'b1; // Increment the counter
end

always @(posedge slowclock) begin
    if (clean) begin // If clean signal is active
        col <= 0; // Reset column position
        lin <= 0; // Reset line position
        idx <= 0; // Reset index position
        init_idx <= 0; // Reset initial message index
        state <= STATE_INIT; // Set state to initial message
        full <= 0; // Clear full signal
    end else begin
        case (state)
            STATE_INIT: begin // State for initial message
                o_address <= {lin, col}; // Set output address
                o_data <= init_text[8*(init_len - init_idx - 1) +: 8]; // Set output data
                o_we <= 1'b1; // Set write enable
                init_idx <= init_idx + 1; // Increment initial message index

                // Update screen position
                if (init_text[8*(init_len - init_idx - 1) +: 8] == 8'h0A) begin // If newline character is detected
                    col <= 0; // Reset column position
                    lin <= next_lin; // Increment line position
                end else begin
                    if (col == maxcol) begin // If end of column
                        col <= 0; // Reset column position
                        lin <= next_lin; // Increment line position
                    end else begin
                        col <= col + 1'b1; // Increment column position
                    end
                end

                if (init_idx == init_len - 1) begin // If end of initial message
                    state <= STATE_WAIT_CMD; // Set state to wait for commands
                    init_idx <= 0; // Reset initial message index
                end
            end

            STATE_WAIT_CMD: begin // State for waiting for user commands
                o_we <= 1'b0; // Disable write enable
                if (i_ena) begin // If enable signal is active
                    state <= STATE_WRITE_TEXT; // Set state to write text
                end
            end

            STATE_WRITE_TEXT: begin // State for writing text
//                o_address <= {lin, col}; // Set output address
//                o_data <= i_data[idx]; // Set output data
//                o_we <= 1'b1; // Set write enable

//                 Update text position
//                idx <= next_idx; // Increment text index

 //                Update screen position
//                if (i_data[idx] == 8'h0A) begin // If newline character is detected
//                    col <= 0; // Reset column position
//                    lin <= next_lin; // Increment line position
//                end else begin
//                    if (col == maxcol) begin // If end of column
//                        col <= 0; // Reset column position
//                        lin <= next_lin; // Increment line position
//                    end else begin
//                        col <= col + 1'b1; // Increment column position
//                    end
//                end

 //                Check if we have reached the end of the screen
//                if (lin == maxlin && col == maxcol) begin // If end of screen
//                    state <= STATE_SCREEN_FULL; // Set state to screen full
//                    full <= 1; // Set full signal
//                end
            end

            STATE_SCREEN_FULL: begin // State for screen full
//                full <= 1; // Set full signal
//                col <= 0; // Reset column position
//                lin <= 0; // Reset line position
//                idx <= 0; // Reset index position
//                state <= STATE_WAIT_CMD; // Set state to wait for commands
            end
        endcase
    end
end

endmodule
