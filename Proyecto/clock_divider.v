module clock_divider #(
    parameter FREQ = 2 // Frecuencia de salida deseada en Hz
)(
    input  clk,     // Reloj de entrada (50 MHz de la DE10-Lite)
    input  rst,     // Reset (activo en alto según tu lógica rst_n = !reset_n)
    output reg clk_div
);

    // El reloj de la placa es de 50,000,000 Hz
    localparam CLK_INPUT_FREQ = 50000000;
    
    // Calculamos el valor máximo del contador para la mitad del periodo
    // Con 50MHz y FREQ=2, el contador llega a 12,500,000
    localparam COUNT_MAX = CLK_INPUT_FREQ / (2 * FREQ);

    reg [31:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 32'd0;
            clk_div <= 1'b0;
        end else begin
            if (counter >= (COUNT_MAX - 1)) begin
                counter <= 32'd0;
                clk_div <= ~clk_div; // Invierte la señal para crear el pulso
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule