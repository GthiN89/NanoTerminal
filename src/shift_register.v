module shift_register (
    input clk,
    input reset,
    input reg  data_in,
    output reg data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 1'b0;
        end else begin
            data_out <= {data_out, data_in};
        end
    end
endmodule