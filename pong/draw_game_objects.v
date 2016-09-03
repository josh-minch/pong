/*
    Draw 2 paddles, 1 ball, and associated movement modules to screen thru output rgb signal
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

    parameter L_PADDLE_COLOR      = 8'b11111111;
    parameter R_PADDLE_COLOR      = 8'b11111111;
    parameter BALL_COLOR          = 8'b11111111;

    parameter PADDLE_HEIGHT       = 40;
    parameter PADDLE_WIDTH        = 10;
    parameter BALL_HEIGHT         = 8;
    parameter BALL_WIDTH          = 6;

    parameter L_PADDLE_CENTER_COL = 27;
    parameter R_PADDLE_CENTER_COL = DISP_COLS - 27;

    wire [11:0] l_paddle_center_row;
    wire [7:0]  l_paddle;
    wire [11:0] r_paddle_center_row;
    wire [7:0]  r_paddle;
    wire [11:0] ai_l_paddle_center_row;
    wire [11:0] ai_r_paddle_center_row;
    wire [11:0] ball_center_col;
    wire [11:0] ball_center_row;
    wire [1:0]  ball_direction;
    wire [7:0]  ball;

    draw_paddle #(
            .PADDLE_COLOR(L_PADDLE_COLOR),
            .PADDLE_CENTER_COL(L_PADDLE_CENTER_COL),
            .PADDLE_HEIGHT(PADDLE_HEIGHT),
            .PADDLE_WIDTH(PADDLE_WIDTH)
        ) draw_left_paddle (
            .move_up_control   (move_up_control),
            .move_down_control (move_down_control),
            .paddle_center_row (ai_l_paddle_center_row),
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
            .paddle_center_row (ai_r_paddle_center_row),
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
        ) inst_player_move_r_paddle (
            .clk               (clk),
            .move_up_control   (move_up_control_p1),
            .move_down_control (move_down_control_p1),
            .paddle_center_row (r_paddle_center_row)
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
    
    move_ball #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS),
            .P_WIDTH(PADDLE_WIDTH),
            .B_HEIGHT(BALL_HEIGHT),
            .B_WIDTH(BALL_WIDTH),
            .L_PADDLE_CENTER_COL(L_PADDLE_CENTER_COL),
            .R_PADDLE_CENTER_COL(R_PADDLE_CENTER_COL)
        ) inst_move_ball (
            .l_center_row     (ai_l_paddle_center_row),
            .r_center_row     (ai_r_paddle_center_row),
            .ball_center_col  (ball_center_col),
            .ball_center_row  (ball_center_row),
            .ball_direction   (ball_direction),
            .clk              (clk)
        );

    ai_move_paddle #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS),
            .PADDLE_SIDE(0)
        ) inst_ai_move_l_paddle (
            .ball_center_row   (ball_center_row),
            .ball_center_col   (ball_center_col),
            .ball_direction    (ball_direction),
            .paddle_center_row (ai_l_paddle_center_row),
            .clk               (clk)
        );

    ai_move_paddle #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS),
            .PADDLE_SIDE(1)
        ) inst_ai_move_r_paddle (
            .ball_center_row   (ball_center_row),
            .ball_center_col   (ball_center_col),
            .ball_direction    (ball_direction),
            .paddle_center_row (ai_r_paddle_center_row),
            .clk               (clk)
        );

    assign rgb = l_paddle | r_paddle | ball;

endmodule