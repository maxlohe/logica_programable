module pwm1 (
    input               MAX10_CLK1_50,
    input      [1:0]    KEY,           // 0 rst, 1 guardad
    input      [9:0]    SW,            //MANUAL/AUTOMATICO
    
    
    input               data_update, 
    input signed [15:0] accel_x,
    input signed [15:0] accel_y,
    input signed [15:0] accel_z,
    
    output     [15:0]   ARDUINO_IO,    // IO[0]=Base, IO[1]=Right, IO[2]=Left
    output     [6:0]    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	 output     [7:0]    vga_ang_base,
    output     [7:0]    vga_ang_right,
    output     [7:0]    vga_ang_left
);

    
    parameter CLK_FREQ    = 50000000;
    parameter SERVO_FREQ  = 50;       
    parameter US_MIN      = 500;
    parameter US_MAX      = 2500; 

    localparam CYCLES_PER_US = CLK_FREQ / 1000000;
    localparam CYCLES_PERIOD = CLK_FREQ / SERVO_FREQ; 
    localparam CYCLES_MIN    = US_MIN * CYCLES_PER_US;
    localparam CYCLES_MAX    = US_MAX * CYCLES_PER_US;
    localparam CYCLES_RANGE  = CYCLES_MAX - CYCLES_MIN;

    // --- Estados de la FSM ---
    localparam ST_MANUAL   = 2'b00;
    localparam ST_RECORD   = 2'b01;
    localparam ST_PLAYBACK = 2'b10;
    localparam ST_FINISH   = 2'b11;

    
    wire [7:0] ang_base, ang_right, ang_left;
    wire rst_n = KEY[0];
    wire auto_mode  = SW[0];
    wire record_btn = KEY[1];
    
    reg [1:0] estado_actual, estado_siguiente;
    
    wire [23:0] ram_salida;
    reg  [23:0] ram_entrada;
    reg         ram_escribir_n; 
    reg  [3:0]  ram_direccion;
    
    reg  [3:0]  posiciones_guardadas; 
    reg  [3:0]  posicion_actual;      
    reg  [25:0] timer_1segundo;       
    reg         termino_rutina;       

    
    reg key1_anterior;
    always @(posedge MAX10_CLK1_50) key1_anterior <= record_btn;
    wire pulso_guardar = (key1_anterior == 1'b1 && record_btn == 1'b0);

    
    convertidor_rotacion unidad_fisica (
        .clk(MAX10_CLK1_50),
        .reset_n(rst_n),
        .data_update(data_update),
        .data_x(accel_x),
        .data_y(accel_y),
        .data_z(accel_z),
        .angulo_base(ang_base),
        .angulo_right(ang_right),
        .angulo_left(ang_left)
    );

    
    memory_RAM #(.NBits(24), .NAddr(4)) memoria_posiciones (
        .clk(MAX10_CLK1_50),
        .rst_a(rst_n),
        .wr_en(ram_escribir_n),
        .Data_in(ram_entrada),
        .Data_address(ram_direccion),
        .Data_out(ram_salida)
    );

    //FSM
    
    always @(posedge MAX10_CLK1_50 or negedge rst_n) begin
        if (!rst_n) estado_actual <= ST_MANUAL;
        else        estado_actual <= estado_siguiente;
    end

    
    always @(*) begin
        case (estado_actual)
            ST_MANUAL: begin
                if (auto_mode) 
                    estado_siguiente = ST_PLAYBACK;// SECUENCIA
                else if (pulso_guardar && posiciones_guardadas < 15)
                    estado_siguiente = ST_RECORD;//GUADRAR
                else
                    estado_siguiente = ST_MANUAL;
            end
            ST_RECORD: begin
                estado_siguiente = ST_MANUAL; // regresa tras un ciclo de escritura
            end
            ST_PLAYBACK: begin
                if (!auto_mode)
                    estado_siguiente = ST_MANUAL;
                else if (posicion_actual >= posiciones_guardadas)
                    estado_siguiente = ST_FINISH;
                else
                    estado_siguiente = ST_PLAYBACK;
            end
            ST_FINISH: begin
                if (!auto_mode) estado_siguiente = ST_MANUAL;
                else            estado_siguiente = ST_FINISH;
            end
            default: estado_siguiente = ST_MANUAL;
        endcase
    end

    // Bloque 3: Lógica de Salida y Contadores (Secuencial)
    always @(posedge MAX10_CLK1_50 or negedge rst_n) begin
        if (!rst_n) begin
            posiciones_guardadas <= 0;
            posicion_actual <= 0;
            timer_1segundo <= 0;
            termino_rutina <= 0;
            ram_escribir_n <= 1;
            ram_direccion <= 0;
        end else begin
            ram_escribir_n <= 1; // Default: No escribir

            case (estado_actual)
                ST_MANUAL: begin
                    termino_rutina <= 0;
                    posicion_actual <= 0;
                    timer_1segundo <= 0;
                    ram_direccion <= posiciones_guardadas;
                end
                ST_RECORD: begin
                    ram_entrada <= {ang_base, ang_right, ang_left};
                    ram_escribir_n <= 0; // Guardar en RAM
                    posiciones_guardadas <= posiciones_guardadas + 1;
                end
                ST_PLAYBACK: begin
                    ram_direccion <= posicion_actual;
                    if (timer_1segundo < 50000000) begin
                        timer_1segundo <= timer_1segundo + 1;
                    end else begin
                        timer_1segundo <= 0;
                        posicion_actual <= posicion_actual + 1;
                    end
                end
                ST_FINISH: begin
                    termino_rutina <= 1;
                end
            endcase
        end
    end

    
    wire [7:0] final_base  = (estado_actual == ST_PLAYBACK) ? ram_salida[23:16] : ang_base;
    wire [7:0] final_right = (estado_actual == ST_PLAYBACK) ? ram_salida[15:8]  : ang_right;
    wire [7:0] final_left  = (estado_actual == ST_PLAYBACK) ? ram_salida[7:0]   : ang_left;

    
    reg [20:0] counter;

    wire [31:0] calc_base  = (final_base  * CYCLES_RANGE) / 180;
    wire [31:0] calc_right = (final_right * CYCLES_RANGE) / 180;
    wire [31:0] calc_left  = (final_left  * CYCLES_RANGE) / 180;

    wire [20:0] duty_base  = CYCLES_MIN + calc_base[20:0];
    wire [20:0] duty_right = CYCLES_MIN + calc_right[20:0];
    wire [20:0] duty_left  = CYCLES_MIN + calc_left[20:0];

    always @(posedge MAX10_CLK1_50 or negedge rst_n) begin
        if (!rst_n) counter <= 0;
        else begin
            if (counter >= CYCLES_PERIOD - 1) counter <= 0;
            else counter <= counter + 1;
        end
    end

    assign ARDUINO_IO[0] = (counter < duty_base);
    assign ARDUINO_IO[1] = (counter < duty_right);
    assign ARDUINO_IO[2] = (counter < duty_left);

   
    wire [3:0] uni, dec, cen, uni2, dec2, cen2;
    wire [7:0] ang_disp  = (final_right > 180) ? 8'd180 : final_right;
    wire [7:0] ang_disp2 = (final_left > 180)  ? 8'd180 : final_left;

    assign uni = ang_disp % 10;
    assign dec = (ang_disp / 10) % 10;
    assign cen = (ang_disp / 100) % 10;
    assign uni2 = ang_disp2 % 10;
    assign dec2 = (ang_disp2 / 10) % 10;
    assign cen2 = (ang_disp2 / 100) % 10;

    seg7 d0 (.in(uni),  .display(HEX0));
    seg7 d1 (.in(dec),  .display(HEX1));
    seg7 d2 (.in(cen),  .display(HEX2));
    seg7 d3 (.in(uni2), .display(HEX3));
    seg7 d4 (.in(dec2), .display(HEX4));
    seg7 d5 (.in(cen2), .display(HEX5));
	 
	 
	 assign vga_ang_base  = final_base;
    assign vga_ang_right = final_right;
    assign vga_ang_left  = final_left;

endmodule