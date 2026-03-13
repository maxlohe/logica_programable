module receiver(
    input              MAX10_CLK1_50,
    input      [9:0]   SW,           
    output     [0:6]   HEX0,         
    output     [0:6]   HEX1,         
    output     [0:6]   HEX2,         
    input      [35:0]  GPIO	 
);

    wire rst = SW[9];

    wire [7:0] dato_recibido;
    wire rx_ready;

    
    reg [7:0] dato_reg = 8'd0;

    UART_Rx #(
        .BAUD_RATE(9600),
        .CLOCK_FREQ(50000000)
    ) my_uart_rx (
        .clk(MAX10_CLK1_50),
        .rst(rst),
        .rx_in(GPIO[0]),         
        .data_out(dato_recibido),
        .ready(rx_ready)
    );

    
    always @(posedge MAX10_CLK1_50 or posedge rst) begin
        if (rst)
            dato_reg <= 8'd0;
        else if (rx_ready)
            dato_reg <= dato_recibido;
    end

    
    wire [3:0] un = dato_reg % 10;
    wire [3:0] de = (dato_reg / 10) % 10;
    wire [3:0] ce = (dato_reg / 100) % 10;

    Lab2 dec_unidades (
        .bcd_in(un),
        .bcd_out(HEX0)
    );

    Lab2 dec_decenas (
        .bcd_in(de),
        .bcd_out(HEX1)
    );

    Lab2 dec_centenas (
        .bcd_in(ce),
        .bcd_out(HEX2)
    );

endmodule