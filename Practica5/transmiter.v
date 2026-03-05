module transmiter(
    input              CLOCK_50,   
    input      [9:0]   SW,         // SW[7:0] datos, SW[9] reset
    input      [3:0]   KEY,        // KEY[0] enviar
    output     [0:6]   HEX0,       
    output     [0:6]   HEX1,       
    output     [0:6]   HEX2,       
    output     GPIO_0      
);

    
    wire rst = SW[9];
    wire start_signal = ~KEY[0];
    wire uart_busy;
    wire tx_line;

    
    wire [7:0] cuenta = SW[7:0];
    
    wire [3:0] un = cuenta % 10;           
    wire [3:0] de = (cuenta / 10) % 10;    
    wire [3:0] ce = (cuenta / 100) % 10;   

    
    UART_Tx #(
        .BAUD_RATE(9600),
        .CLOCK_FREQ(50000000),
        .BITS(8)
    ) my_uart_tx (
        .clk(CLOCK_50),
        .rst(rst),
        .data_in(cuenta),
        .start(start_signal),
        .tx_out(tx_line),
        .busy(uart_busy)
    );

   
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

    
    assign GPIO_0 = tx_line;

endmodule