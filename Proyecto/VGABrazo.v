module VGABrazo(
    input MAX10_CLK1_50,
    input [7:0] ang_base,
    input [7:0] ang_hombro,
    input [7:0] ang_codo,
    output reg [3:0] vga_r,
    output reg [3:0] vga_g,
    output reg [3:0] vga_b,
    output hsync_out, 
    output vsync_out
);

    wire inDisplayArea;
    wire [9:0] CounterX, CounterY;
    reg pixel_tick = 0;

    // Generador de 25MHz
    always @(posedge MAX10_CLK1_50) pixel_tick <= ~pixel_tick;

    hvsync_generator hvsync(
        .clk(MAX10_CLK1_50), .pixel_tick(pixel_tick),
        .vga_h_sync(hsync_out), .vga_v_sync(vsync_out),
        .CounterX(CounterX), .CounterY(CounterY),
        .inDisplayArea(inDisplayArea)
    );

    
    reg [1:0] motor_sel;
    always @(*) begin
        if      (CounterY >= 100 && CounterY < 116) motor_sel = 2'd0; // Base
        else if (CounterY >= 140 && CounterY < 156) motor_sel = 2'd1; // Hombro
        else if (CounterY >= 180 && CounterY < 196) motor_sel = 2'd2; // Codo
        else                                        motor_sel = 2'd3; // Fuera de zona
    end

    
    reg [7:0] valor_actual;
    reg [7:0] ascii;
    wire [3:0] char_index = (CounterX >= 200 && CounterX < 288) ? (CounterX - 200) >> 3 : 4'd15;

    always @(*) begin
        ascii = " "; 
        valor_actual = 8'd0;

        if (motor_sel != 2'd3 && char_index < 11) begin
            
            case(motor_sel)
                2'd0: valor_actual = ang_base;
                2'd1: valor_actual = ang_hombro;
                2'd2: valor_actual = ang_codo;
            endcase

            
            case(char_index)
                4'd0: case(motor_sel) 2'd0: ascii = "B"; 2'd1: ascii = "H"; 2'd2: ascii = "C"; endcase
                4'd1: case(motor_sel) 2'd0: ascii = "a"; 2'd1: ascii = "o"; 2'd2: ascii = "o"; endcase
                4'd2: case(motor_sel) 2'd0: ascii = "s"; 2'd1: ascii = "m"; 2'd2: ascii = "d"; endcase
                4'd3: case(motor_sel) 2'd0: ascii = "e"; 2'd1: ascii = "b"; 2'd2: ascii = "o"; endcase
                4'd4: case(motor_sel) 2'd1: ascii = "r"; default: ascii = " "; endcase
                4'd5: case(motor_sel) 2'd1: ascii = "o"; default: ascii = " "; endcase
                4'd6: ascii = ":";
                4'd7: ascii = (valor_actual / 100) + 8'd48;     
                4'd8: ascii = ((valor_actual / 10) % 10) + 8'd48; 
                4'd9: ascii = (valor_actual % 10) + 8'd48;       
                4'd10: ascii = 8'd176; 
                default: ascii = " ";
            endcase
        end
    end

    
    wire [11:0] rom_addr = (ascii << 4) + (CounterY[3:0]);
    wire [7:0] font_row;
    
    font_rom font_unit(.addr(rom_addr), .data(font_row));

    
    wire pixel_on = font_row[7 - CounterX[2:0]];

    
    always @(posedge MAX10_CLK1_50) begin
        if (inDisplayArea && (motor_sel != 2'd3) && (char_index < 11) && pixel_on) begin
            vga_r <= 4'hF; vga_g <= 4'hF; vga_b <= 4'hF;
        end else begin
            vga_r <= 4'h0; vga_g <= 4'h0; vga_b <= 4'h0;
        end
    end

endmodule