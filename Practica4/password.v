module password(
    input        CLOCK_50,
    input  [9:0] SW,    
    input  [3:0] KEY,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3
);

wire rst    = ~KEY[0]; 
wire valida = ~KEY[1]; 

reg v_reg;//valor del botón en el ciclo anterior
wire v_pulsado = (valida && !v_reg);//está presionado ahora (valida) y no estaba presionado antes (!v_reg).

always @(posedge CLOCK_50 or posedge rst) begin
    if (rst)
        v_reg <= 1'b0;
    else
        v_reg <= valida;// guarda el estado anterior
end

parameter IDLE=3'd0, D1=3'd1, D2=3'd2, D3=3'd3, GOOD=3'd4, BAD=3'd5;

reg [2:0] current, next;

always @(posedge CLOCK_50 or posedge rst) begin
    if (rst)
        current <= IDLE;
    else
        current <= next;
end

always @(*) begin
    next=current;
    case (current)
        IDLE: begin
            if (v_pulsado && (SW[3:0] == 4'd2))
                next = D1;
            else if (v_pulsado)
                next = BAD;
        end

        D1: begin
            if (v_pulsado && (SW[3:0] == 4'd0))
                next = D2;
            else if (v_pulsado)
                next = BAD;
        end

        D2: begin
            if (v_pulsado && (SW[3:0] == 4'd0))
                next = D3;
            else if (v_pulsado)
                next = BAD;
        end

        D3: begin
            if (v_pulsado && (SW[3:0] == 4'd7))
                next = GOOD;
            else if (v_pulsado)
                next = BAD;
        end

        GOOD: begin
          if(valida)
            next = GOOD;
          else
            next = IDLE;
          end
        BAD:  begin
          if(valida)
            next = BAD;
          else
            next = IDLE;
          end

        default: next = IDLE;
    endcase
end

reg [3:0] out [3:0];

always @(*) begin
    out[0] = 4'hF;
    out[1] = 4'hF;
    out[2] = 4'hF;
    out[3] = 4'hF;

    case (current)
        IDLE: ;

        D1: begin
            out[0] = 4'd2;
        end

        D2: begin
            out[0] = 4'd2;
            out[1] = 4'd0;
        end

        D3: begin
            out[0] = 4'd2;
            out[1] = 4'd0;
            out[2] = 4'd0;
        end

        GOOD: begin
            out[3] = 4'd13;
            out[2] = 4'd14;
            out[1] = 4'd14;
            out[0] = 4'd12;
        end

        BAD: begin
            out[2] = 4'd10;
            out[1] = 4'd11;
            out[0] = 4'd12;
        end
    endcase
end

Lab2 h0(.bcd_in(out[0]), .bcd_out(HEX3));
Lab2 h1(.bcd_in(out[1]), .bcd_out(HEX2));
Lab2 h2(.bcd_in(out[2]), .bcd_out(HEX1));
Lab2 h3(.bcd_in(out[3]), .bcd_out(HEX0));

endmodule