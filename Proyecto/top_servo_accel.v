module top_servo_accel (
    input  MAX10_CLK1_50,
    input  [1:0] KEY,
    input  [9:0] SW,
    output [9:0] LEDR,
    
    output GSENSOR_CS_N,
    input  [2:1] GSENSOR_INT,
    output GSENSOR_SCLK,
    inout  GSENSOR_SDI, GSENSOR_SDO,
    
    output [15:0] ARDUINO_IO,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS
);
    wire [15:0] ax, ay, az;
    wire update_tick;
    
    
    wire [7:0] ang_base_vga;
    wire [7:0] ang_hombro_vga;
    wire [7:0] ang_codo_vga;

    
    accel sensor_inst (
        .MAX10_CLK1_50(MAX10_CLK1_50),
        .KEY(KEY),
        .GSENSOR_CS_N(GSENSOR_CS_N),
        .GSENSOR_INT(GSENSOR_INT),
        .GSENSOR_SCLK(GSENSOR_SCLK),
        .GSENSOR_SDI(GSENSOR_SDI),
        .GSENSOR_SDO(GSENSOR_SDO),
        .data_x(ax), .data_y(ay), .data_z(az),
        .data_update(update_tick)
    );


  pwm1 controlador_servos (
        .MAX10_CLK1_50(MAX10_CLK1_50),
        .KEY(KEY),
        .SW(SW),
        .data_update(update_tick),
        .accel_x(ax), .accel_y(ay), .accel_z(az),
        .ARDUINO_IO(ARDUINO_IO),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
        .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
        
        .vga_ang_base(ang_base_vga),
        .vga_ang_right(ang_hombro_vga),
        .vga_ang_left(ang_codo_vga)
    );

    
    VGABrazo controlador_vga (
        .MAX10_CLK1_50(MAX10_CLK1_50),
        .ang_base(ang_base_vga),
        .ang_hombro(ang_hombro_vga),
        .ang_codo(ang_codo_vga),
        .vga_r(VGA_R),
        .vga_g(VGA_G),
        .vga_b(VGA_B),
        .hsync_out(VGA_HS),
        .vsync_out(VGA_VS)
    );

    assign LEDR = {9'b0, update_tick};

endmodule