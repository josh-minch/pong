/*  Draws paddles and ball to screen through output rgb signal. Moves ball and
paddles, and select whether paddles are controlled by ai or player.

Set object colors, paddle position, and object sizes with local parameters */

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
        input select_l_paddle_player,
        input select_r_paddle_player,
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

    parameter L_PADDLE_CENTER_COL = 55;
    parameter R_PADDLE_CENTER_COL = DISP_COLS - 55;

    wire [11:0] l_paddle_center_row;
    wire [11:0] r_paddle_center_row;
    wire [7:0]  l_paddle_rgb;
    wire [7:0]  r_paddle_rgb;
    wire [11:0] ball_center_col;
    wire [11:0] ball_center_row;
    wire [1:0]  ball_direction;
    wire [7:0]  ball;

    // Draw objects to screen
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
            .paddle_rgb        (l_paddle_rgb),
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
            .paddle_rgb        (r_paddle_rgb),
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

    // Move objects
    move_ball #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS),
            .P_WIDTH(PADDLE_WIDTH),
            .B_HEIGHT(BALL_HEIGHT),
            .B_WIDTH(BALL_WIDTH),
            .L_PADDLE_CENTER_COL(L_PADDLE_CENTER_COL),
            .R_PADDLE_CENTER_COL(R_PADDLE_CENTER_COL)
        ) inst_move_ball (
            .l_center_row     (l_paddle_center_row),
            .r_center_row     (r_paddle_center_row),
            .ball_center_col  (ball_center_col),
            .ball_center_row  (ball_center_row),
            .ball_direction   (ball_direction),
            .clk              (clk)
        );

    player_move_paddle #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS)
        ) player_move_r_paddle (
            .clk               (clk),
            .move_up_control   (move_up_control_p1),
            .move_down_control (move_down_control_p1),
            .paddle_center_row (player_r_paddle_center_row)
        );
    player_move_paddle #(
        .DISP_COLS(DISP_COLS),
        .DISP_ROWS(DISP_ROWS)
        ) player_move_l_paddle (
            .clk               (clk),
            .move_up_control   (move_up_control_p0),
            .move_down_control (move_down_control_p0),
            .paddle_center_row (player_l_paddle_center_row)
        );

    ai_move_paddle #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS),
            .PADDLE_SIDE(0)
        ) ai_move_l_paddle (
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
        ) ai_move_r_paddle (
            .ball_center_row   (ball_center_row),
            .ball_center_col   (ball_center_col),
            .ball_direction    (ball_direction),
            .paddle_center_row (ai_r_paddle_center_row),
            .clk               (clk)
        );

    // Select if player or ai control paddle
    assign l_paddle_center_row = select_l_paddle_player ?
                     player_l_paddle_center_row : ai_l_paddle_center_row;
    assign r_paddle_center_row = select_r_paddle_player ?
                     player_r_paddle_center_row : ai_r_paddle_center_row;

    assign rgb = l_paddle_rgb | r_paddle_rgb | ball;

endmodule