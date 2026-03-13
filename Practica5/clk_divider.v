

module clk_divider#(parameter FREQ=5_000_000)(
    input clk,
    input rst, //SW 0
    output reg clk_div
);

    reg [31:0] count;
    parameter CLK_FREQ=50_000_000;
    parameter constantNumber = CLK_FREQ/(2*FREQ);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 32'b0;
            clk_div <= 1'b0;
        end else begin
            if (count == (constantNumber - 1)) begin
                count <= 32'b0;
                clk_div <= ~clk_div;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule