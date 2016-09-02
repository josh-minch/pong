/*  
    Scales an input clock down by some SCALER value. 

    slower_clk = clk / SCALER 
*/

module clock_scaler 
    #(
        parameter SCALER_WIDTH = 31
    )
    (  
        input  clk,
		  input  [SCALER_WIDTH - 1 : 0] scaler,
        output reg slower_clk
    );

    reg [SCALER_WIDTH:0] counter = 0;
	 
	 initial begin
		slower_clk <= 1'b0;
	 end 
	 
    always @(posedge clk) begin

        counter <= counter + 1;

        if (counter == scaler) begin
            slower_clk <= ~slower_clk;
            counter <= 0;
        end
    end

endmodule