module clockCounter # (
   localparam CLOCK_SPEED = 25000000
) (
        input clk,
        input rst, //active low
        output reg [7:0] counterS,
        output reg [14:0] counterMS
);

        reg [32:0] clockCounter;



        always @(posedge clk) begin
            if (~rst) begin
                clockCounter <= 0;
                counterS     <= 0;
                counterMS    <= 0;
            end else
            if (clockCounter == CLOCK_SPEED) begin
                clockCounter <= 0;
                counterS <= counterS + 1;
            end else
            if  (clockCounter[0:16] == CLOCK_SPEED[0:16]) begin
                counterMS <= counterMS + 1;
            end
        end
endmodule
                
                
     