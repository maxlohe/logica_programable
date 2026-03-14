module convertidor_rotacion (
    input clk,
    input reset_n,
    input data_update,
    input signed [15:0] data_x,
    input signed [15:0] data_y,
    input signed [15:0] data_z,
    
    output reg [7:0] angulo_base,
    output reg [7:0] angulo_right,
    output reg [7:0] angulo_left
);

    // Límites físicos 
    localparam BASE_MIN  = 8'd0,   BASE_MAX  = 8'd180, BASE_MID = 8'd90;
    localparam RIGHT_MIN = 8'd90,  RIGHT_MAX = 8'd150, RIGHT_MID = 8'd120;
    localparam LEFT_MIN  = 8'd130, LEFT_MAX  = 8'd180, LEFT_MID = 8'd155;

    
    wire signed [23:0] calc_base, calc_right, calc_left;

    
    
    // BASE: (256 -> 0, -256 -> 180) 
    // 0 + ((-data_x + 256) * 180) / 512
    assign calc_base  = ((-data_x + 16'sd256) * 180) >>> 9;

    // RIGHT: (256 -> 90, -256 -> 150) 
    //  90 + ((-data_y + 256) * 60) / 512
    assign calc_right = 16'sd90 + (((-data_y + 16'sd256) * 60) >>> 9);

    // LEFT: (256 -> 130, -256 -> 180) ¡
    // 130 + ((-data_z + 256) * 50) / 512
    assign calc_left  = 16'sd130 + (((-data_z + 16'sd256) * 50) >>> 9);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            angulo_base  <= BASE_MID;
            angulo_right <= RIGHT_MID;
            angulo_left  <= LEFT_MID;
        end 
        else if (data_update) begin
            
           
            
            // BASE
            if (calc_base > BASE_MAX) angulo_base <= BASE_MAX;
            else if (calc_base < BASE_MIN) angulo_base <= BASE_MIN;
            else angulo_base <= calc_base[7:0];

            // RIGHT
            if (calc_right > RIGHT_MAX) angulo_right <= RIGHT_MAX;
            else if (calc_right < RIGHT_MIN) angulo_right <= RIGHT_MIN;
            else angulo_right <= calc_right[7:0];

            // LEFT
            if (calc_left > LEFT_MAX) angulo_left <= LEFT_MAX;
            else if (calc_left < LEFT_MIN) angulo_left <= LEFT_MIN;
            else angulo_left <= calc_left[7:0];
            
        end
    end
endmodule