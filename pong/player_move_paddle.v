module player_move_paddle
    #(
        parameter DISP_COLS     = 800,
        parameter DISP_ROWS     = 600
    )
    (
        input clk,
        input move_up_control,
        input move_down_control,

        output reg [11:0] paddle_center_row = DISP_ROWS / 2
    );

    parameter SCALER = 40000;

    wire slower_clk;

    clock_scaler inst_clock_scaler (
            .clk        (clk),
            .scaler     (SCALER),
            .slower_clk (slower_clk)
        );

    always@ (posedge slower_clk) begin

        if (move_up_control)
            paddle_center_row = paddle_center_row + 1;
        if (move_down_control) 
            paddle_center_row = paddle_center_row - 1;          
    end

endmodule