module debouncer (
input CLOCK_50,
input [1:0] KEY,
output   LEDR
);

wire rst= ~KEY[0];
wire button = KEY[1];
// button=0 cuando esta presionado
// button=1 esta suelto

reg [24:0]counter_pressed, counter_not_pressed;
reg button_state = 1'b0; // esta suelto

initial begin
counter_pressed <= 25'b0;
counter_not_pressed <= 25'b0;
end

always @(posedge CLOCK_50 or posedge rst)
begin
	if(rst)
		begin
		counter_pressed<= 25'b0;
		counter_not_pressed<= 25'b0;
		end
	
	else
		begin
		
			//	PRESIONADO
			// cuenta si se presiona (button=0) y estaba suelto (buton state=0)
			// Si la señal es estable por 20ms se considera valida	
			if (button == 0 && button_state == 0) begin
            if (counter_pressed < 25'd1000000)
                counter_pressed <= counter_pressed + 1;
            else begin
                button_state <= 1;
                counter_pressed <= 0;
            end
        end
        else
            counter_pressed <= 0;
	
			//	SUELTO
			// cuenta si suelto (button=1) y estaba presionado (buton state=1)
			// Si la señal es estable por 20ms se considera valida	
			if (button == 1 && button_state == 1) begin
            if (counter_not_pressed < 25'd1000000)
                counter_not_pressed <= counter_not_pressed + 1;
            else begin
                button_state <= 0;
                counter_not_pressed <= 0;
            end
        end
        else
            counter_not_pressed <= 0;
			
end
end
assign LEDR=button_state;
//assign LEDR[1]=~button;
endmodule