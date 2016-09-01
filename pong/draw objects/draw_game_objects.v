/*
    Draw game objects to screen thru output rgb signal
*/

module draw_game_objects
    #(
        parameter DISP_COLS     = 800,
        parameter DISP_ROWS     = 600
    )
    (
        input move_up_control_p0,
        input move_down_control_p0,
        input move_up_control_p1,
        input move_down_control_p1,
        input [11:0] col_counter,
        input [11:0] row_counter,

        output [7:0] rgb,

        input clk
    );

    parameter PADDLE_HEIGHT       = 44;
    parameter PADDLE_WIDTH        = 12;
    parameter BALL_HEIGHT         = 8;
    parameter BALL_WIDTH          = 6;

    parameter L_PADDLE_CENTER_COL = 15;
    parameter R_PADDLE_CENTER_COL = DISP_COLS - 15;

    parameter BALL_COLOR          = 8'b11100000;
    parameter L_PADDLE_COLOR      = 8'b11111111;
    parameter R_PADDLE_COLOR      = 8'b11111111;

    wire [11:0] l_paddle_center_row;
    wire [7:0]  l_paddle;
    wire [11:0] r_paddle_center_row;
    wire [7:0]  r_paddle;
    wire [11:0] ball_center_col;
    wire [11:0] ball_center_row;

    draw_paddle #(
            .PADDLE_COLOR(L_PADDLE_COLOR),
            .PADDLE_CENTER_COL(L_PADDLE_CENTER_COL),
            .PADDLE_HEIGHT(PADDLE_HEIGHT),
            .PADDLE_WIDTH(PADDLE_WIDTH)
        ) draw_left_paddle (
            .move_up_control   (move_up_control),
            .move_down_control (move_down_control),
            .paddle_center_row (l_paddle_center_row),
            .col_counter       (col_counter),
            .row_counter       (row_counter),
            .paddle_rgb        (l_paddle),
            .clk               (clk)
        );

    draw_paddle #(
            .PADDLE_COLOR(R_PADDLE_COLOR),
            .PADDLE_CENTER_COL(R_PADDLE_CENTER_COL),
            .PADDLE_HEIGHT(PADDLE_HEIGHT),
            .PADDLE_WIDTH(PADDLE_WIDTH)
        ) draw_right_paddle (
            .move_up_control   (move_up_control),
            .move_down_control (move_down_control),
            .paddle_center_row (r_paddle_center_row),
            .col_counter       (col_counter),
            .row_counter       (row_counter),
            .paddle_rgb        (r_paddle),
            .clk               (clk)
        );

    draw_ball #(
        .BALL_COLOR(BALL_COLOR),
        .BALL_HEIGHT(BALL_HEIGHT),
        .BALL_WIDTH(BALL_WIDTH)
    ) inst_draw_ball (
        .ball_center_row (ball_center_row),
        .ball_center_col (ball_center_col),
        .col_counter     (col_counter),
        .row_counter     (row_counter),
        .ball_rgb        (ball),
        .clk             (clk)
    );

    player_move_paddle #(
        .DISP_COLS(DISP_COLS),
        .DISP_ROWS(DISP_ROWS)
        ) inst_player_move_l_paddle (
            .clk               (clk),
            .move_up_control   (move_up_control_p0),
            .move_down_control (move_down_control_p0),
            .paddle_center_row (l_paddle_center_row)
        );

    player_move_paddle #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS)
        ) inst_player_move_r_paddle (
            .clk               (clk),
            .move_up_control   (move_up_control_p1),
            .move_down_control (move_down_control_p1),
            .paddle_center_row (r_paddle_center_row)
        );

    assign rgb = l_paddle | r_paddle | ball; // | top | bottom;

endmodule