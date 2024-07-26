module textBuffer (
    input clk,
    input byteReady,
    input [7:0] data,
    input [10:0] outputCharIndex, // Updated to 11-bit address
    output [7:0] outByte
);

    reg we = 0;
    reg [10:0] addr;
    reg [7:0] din;
    wire [7:0] dout;

        charbuf_uart charMem (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    reg [10:0] inputCharIndex = 0;
    reg [1:0] state = 0;

    localparam WAIT_FOR_NEXT_CHAR_STATE = 0;
    localparam WAIT_FOR_TRANSFER_FINISH = 1;
    localparam SAVING_CHARACTER_STATE = 2;

    always @(posedge clk) begin
        case (state)
            WAIT_FOR_NEXT_CHAR_STATE: begin
                if (byteReady == 0)
                    state <= WAIT_FOR_TRANSFER_FINISH;
            end
            WAIT_FOR_TRANSFER_FINISH: begin
                if (byteReady == 1)
                    state <= SAVING_CHARACTER_STATE;
            end
            SAVING_CHARACTER_STATE: begin
                inputCharIndex <= inputCharIndex + 1;
                addr <= inputCharIndex;
                din <= data;
                we <= 1;
                state <= WAIT_FOR_NEXT_CHAR_STATE;
            end
        endcase
    end

    assign outByte = dout;

endmodule