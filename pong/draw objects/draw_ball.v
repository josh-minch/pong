module draw_ball
    #(
        parameter BALL_COLOR  = 8'b11111111, // default white
        parameter BALL_HEIGHT = 8,
        parameter BALL_WIDTH  = 6
    )
    (
        input [11:0] ball_center_row,
        input [11:0] ball_center_col,
        input [11:0] col_counter,
        input [11:0] row_counter,

        output reg [7:0] ball_rgb,

        input clk
    );

    draw_rectangle #(
            .RECT_COLOR(BALL_COLOR)
        ) inst_draw_rectangle (
            .col_counter  (col_counter),
            .row_counter  (row_counter),
            .top_bound    (ball_center_row - (BALL_HEIGHT/2)),
            .bottom_bound (ball_center_row + (BALL_HEIGHT/2)),
            .left_bound   (ball_center_col - (BALL_WIDTH/2) ),
            .right_bound  (ball_center_col + (BALL_WIDTH/2) ),
            .rgb          (ball_rgb),
            .clk          (clk)
        );

    move_ball #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS),
            .UP_LEFT(UP_LEFT),
            .DOWN_LEFT(DOWN_LEFT),
            .UP_RIGHT(UP_RIGHT),
            .DOWN_RIGHT(DOWN_RIGHT)
        ) inst_move_ball (
            .ball_direction (ball_direction),
            .ball_center_col(ball_center_col),
            .ball_center_col(ball_center_row),
            .clk            (clk)
        );

endmodule