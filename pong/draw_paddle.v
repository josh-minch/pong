module draw_paddle
    #(
        parameter PADDLE_COLOR = 8'b11111111, // default white
        parameter PADDLE_CENTER_COL = 15,
        parameter PADDLE_HEIGHT     = 44,
        parameter PADDLE_WIDTH      = 14
    )
    (
        input move_up_control,
        input move_down_control,
        input [11:0] paddle_center_row,
        input [11:0] col_counter,
        input [11:0] row_counter,

        output [7:0] paddle_rgb,

        input clk
    );

    draw_rectangle #(
            .RECT_COLOR(PADDLE_COLOR)
        ) inst_draw_rectangle (
            .col_counter  (col_counter),
            .row_counter  (row_counter),
            .top_bound    (paddle_center_row - (PADDLE_HEIGHT / 2)),
            .bottom_bound (paddle_center_row + (PADDLE_HEIGHT / 2)),
            .left_bound   (PADDLE_CENTER_COL -  (PADDLE_WIDTH / 2)),
            .right_bound  (PADDLE_CENTER_COL +  (PADDLE_WIDTH / 2)),
            .rgb          (paddle_rgb),
            .clk          (clk)
        );

endmodule