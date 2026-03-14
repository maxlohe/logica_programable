module accel (
   input ADC_CLK_10, MAX10_CLK1_50,
   input [1:0] KEY,
   output GSENSOR_CS_N,
   input [2:1] GSENSOR_INT,
   output GSENSOR_SCLK,
   inout GSENSOR_SDI, GSENSOR_SDO,
   output [15:0] data_x, data_y, data_z, 
   output data_update
);

   localparam SPI_CLK_FREQ  = 200;
   localparam UPDATE_FREQ   = 1;

   wire reset_n;
   wire clk, spi_clk, spi_clk_out;
   
   // Cables internos para recibir los datos del sensor en tiempo real
   wire [15:0] raw_x, raw_y, raw_z;
   wire raw_update;

   // PLL Instantiation
   PLL ip_inst (
      .inclk0 ( MAX10_CLK1_50 ),
      .c0 ( clk ),
      .c1 ( spi_clk ),
      .c2 ( spi_clk_out )
   );

   // Instancia del controlador SPI (conectado a cables internos "raw")
   spi_control #(
      .SPI_CLK_FREQ(SPI_CLK_FREQ),
      .UPDATE_FREQ(UPDATE_FREQ))
   spi_ctrl (
      .reset_n(reset_n),
      .clk(clk),
      .spi_clk(spi_clk),
      .spi_clk_out(spi_clk_out),
      .data_update(raw_update),
      .data_x(raw_x), 
      .data_y(raw_y),
      .data_z(raw_z),
      .SPI_SDI(GSENSOR_SDI),
      .SPI_SDO(GSENSOR_SDO),
      .SPI_CSN(GSENSOR_CS_N),
      .SPI_CLK(GSENSOR_SCLK),
      .interrupt(GSENSOR_INT)
   );

   assign reset_n = KEY[0];
   wire rst_n = !reset_n;
   wire clk_slow;

   // Divisor de reloj para reducir la velocidad de actualización
   // Cambia FREQ a 1 para 1 vez por segundo, o 4 para algo un poco más fluido.
   clock_divider #(.FREQ(2)) DIVISOR_REFRESH (
      .clk(MAX10_CLK1_50),
      .rst(rst_n),
      .clk_div(clk_slow)
   );

   // Registros que mantienen el valor "congelado" entre ciclos de clk_slow
   reg [15:0] data_x_reg, data_y_reg, data_z_reg;
   reg update_reg;

   always @(posedge clk_slow or negedge reset_n) begin
      if (!reset_n) begin
         data_x_reg <= 0;
         data_y_reg <= 0;
         data_z_reg <= 0;
         update_reg <= 0;
      end else begin
         data_x_reg <= raw_x;
         data_y_reg <= raw_y;
         data_z_reg <= raw_z;
         update_reg <= ~update_reg; // Genera un cambio para indicar nuevo dato
      end
   end

   // Asignamos los registros lentos a las salidas definitivas del módulo
   assign data_x = data_x_reg;
   assign data_y = data_y_reg;
   assign data_z = data_z_reg;
   assign data_update = update_reg;

endmodule