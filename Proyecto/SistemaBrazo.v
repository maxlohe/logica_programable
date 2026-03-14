module SistemaBrazo(
    input MAX10_CLK1_50,
    input [1:0] KEY,          // Botón para aumentar el ángulo
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS
);

    // --- Registros para los ángulos ---
    reg [7:0] angulo_base   = 8'd45; // Valor estático inicial
    reg [7:0] angulo_hombro = 8'd46; // Este aumentará con el botón
    reg [7:0] angulo_left   = 8'd0;  // Valor por defecto

    // --- Lógica de Debounce para el Botón ---
    // Detecta cuando el botón pasa de NO presionado a SI presionado
    reg btn_reg, btn_sync;
    always @(posedge MAX10_CLK1_50) begin
        btn_sync <= ~KEY[0]; // Los KEY en la mayoría de FPGAs son lógica negativa
        btn_reg <= btn_sync;
    end
    
    wire pulse_key = btn_sync && !btn_reg; // Pulso de un solo ciclo de reloj

    // --- Contador para el ángulo del hombro ---
    always @(posedge MAX10_CLK1_50) begin
        if (pulse_key) begin
				angulo_left <= angulo_hombro + 1'b1;
				angulo_base <= angulo_hombro + 1'b1;
            if (angulo_hombro >= 8'd180) 
                angulo_hombro <= 8'd0; // Reinicia al llegar a 180°
            else
                angulo_hombro <= angulo_hombro + 1'b1;
        end
    end

    // --- Instancia del controlador VGA que ya tienes ---
    VGABrazo u_vga (
        .MAX10_CLK1_50(MAX10_CLK1_50),
        .ang_base(angulo_base),      // Mostrará 45 fijo
        .ang_hombro(angulo_hombro),  // Mostrará el valor que aumenta
        .ang_codo(angulo_left),      // Mostrará 0
        .vga_r(VGA_R),
        .vga_g(VGA_G),
        .vga_b(VGA_B),
        .hsync_out(VGA_HS),
        .vsync_out(VGA_VS)
    );

endmodule