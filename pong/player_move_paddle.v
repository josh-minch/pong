module player_move_paddle
    #(
        parameter DISP_COLS     = 800,
        parameter DISP_ROWS     = 600,
        parameter PADDLE_HEIGHT = 44,
        parameter PADDLE_WIDTH  = 12
    )
    (
        input clk,
        input move_up_control,
        input move_down_control,

        output reg [11:0] paddle_center_row = DISP_ROWS / 2
    );

    parameter SCALER = 50000;

    wire slower_clk;
    reg slower_move_up_control = 0;
    reg slower_move_down_control = 0;

    clock_scaler #(.SCALER_WIDTH(20))
        inst_clock_scaler (
            .clk        (clk),
            .scaler     (SCALER),
            .slower_clk (slower_clk)
        );
        
    always@ (posedge slower_clk) begin
        if (move_up_control && paddle_center_row + PADDLE_HEIGHT/2 >= 50)
            paddle_center_row = paddle_center_row - 1;
        if (move_down_control && paddle_center_row - PADDLE_HEIGHT/2 <= DISP_ROWS - 50) 
            paddle_center_row = paddle_center_row + 1;          
    end

endmodule