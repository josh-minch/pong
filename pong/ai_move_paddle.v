module ai_move_paddle
    #(
        parameter DISP_COLS     = 600,
        parameter DISP_ROWS     = 800,
        parameter PADDLE_SIDE   = 0    

    )
    (
        input [11:0] ball_center_row,
        input [11:0] ball_center_col,
        input [1:0]  ball_direction,
        output reg [11:0] paddle_center_row = DISP_ROWS/2,
        input clk
    );

    parameter L_SIDE = 0;
    parameter R_SIDE = 1;
    
    parameter SCALER = 12000;

    clock_scaler #(.SCALER_WIDTH(20))
        inst_clock_scaler (
            .clk        (clk),
            .scaler     (SCALER),
            .slower_clk (slower_clk)
        );

    assign ball_moving_left = (ball_direction == 2'b00 || ball_direction == 2'b00) ? 1 : 0;

    always @(posedge slower_clk) begin
        if (PADDLE_SIDE == L_SIDE) begin
            if (ball_center_col < DISP_COLS/2 - 50) begin

                if (ball_center_row > paddle_center_row )//&& ball_moving_left)
                    paddle_center_row = paddle_center_row + 1;

                else if (ball_center_row < paddle_center_row) //&& ball_moving_left && paddle_center_row > 2)
                    paddle_center_row = paddle_center_row - 1;

                else if (ball_center_row == paddle_center_row) //&& ball_moving_left && paddle_center_row > 21)
                    paddle_center_row = ball_center_row;
            end
        end
        else if (PADDLE_SIDE == R_SIDE) begin
            if (ball_center_col > DISP_COLS/2 + 50) begin

                if (ball_center_row > paddle_center_row && !ball_moving_left)
                    paddle_center_row = paddle_center_row + 1;

                else if (ball_center_row < paddle_center_row && !ball_moving_left)
                    paddle_center_row = paddle_center_row - 1;

                else if (ball_center_row == paddle_center_row && !ball_moving_left)
                    paddle_center_row = ball_center_row;
            end   
        end
	end

endmodule