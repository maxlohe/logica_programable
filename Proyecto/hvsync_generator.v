module hvsync_generator(
    input clk,                // Reloj de 50MHz
    input pixel_tick,         // Habilitación de 25MHz
    output vga_h_sync,
    output vga_v_sync,
    output reg inDisplayArea,
    output reg [9:0] CounterX = 0,
    output reg [9:0] CounterY = 0
);

    
    wire CounterXmaxed = (CounterX == 799);
    wire CounterYmaxed = (CounterY == 524);

    always @(posedge clk) begin
        if (pixel_tick) begin
            if (CounterXmaxed) CounterX <= 0;
            else CounterX <= CounterX + 1;
        end
    end

    always @(posedge clk) begin
        if (pixel_tick && CounterXmaxed) begin
            if (CounterYmaxed) CounterY <= 0;
            else CounterY <= CounterY + 1;
        end
    end

    
    reg h_sync_reg, v_sync_reg;
    always @(posedge clk) begin
        if (pixel_tick) begin
            h_sync_reg <= ~(CounterX >= (640 + 16) && CounterX < (640 + 16 + 96));
            v_sync_reg <= ~(CounterY >= (480 + 10) && CounterY < (480 + 10 + 2));
            inDisplayArea <= (CounterX < 640) && (CounterY < 480);
        end
    end

    assign vga_h_sync = h_sync_reg;
    assign vga_v_sync = v_sync_reg;

endmodule