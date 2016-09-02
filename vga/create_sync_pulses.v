module create_sync_pulses
    #(
    // Number of active columns and rows actually displayed
    parameter DISP_COLS = 640,
    parameter DISP_ROWS = 480,

    // Amount of total cols and rows. Total = display + blank. 
    // Blank cols and rows come from front and back porch and sync pulse
    parameter TOTAL_COLS  = 800, 
    parameter TOTAL_ROWS  = 525
    )
    (
        output reg v_sync,
        output reg h_sync,

        input clk
    ); 

    reg [11:0] row_counter = 0;
    reg [11:0] col_counter = 0;

    always @ (posedge clk) begin
        if (col_counter == TOTAL_COLS - 1) begin
            col_counter = 0;
            if (row_counter == TOTAL_ROWS - 1) begin
                row_counter = 0;
            end
            else begin
                row_counter = row_counter + 1;
            end
        end
        else begin
            col_counter = col_counter + 1;         
        end
    end

    always@ (posedge clk) begin
        assign v_sync = row_counter < DISP_ROWS ? 1 : 0;
        assign h_sync = col_counter < DISP_COLS ? 1 : 0;
    end
    
endmodule