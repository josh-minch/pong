module pong
    #(
        parameter TOTAL_COLS    = 1040, 
        parameter TOTAL_ROWS    = 666,
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
        input h_sync,
        input v_sync,

        output [7:0] rgb,
       
        input clk
    );

    wire [11:0] col_counter;
    wire [11:0] row_counter;

    Sync_To_Count #(
            .TOTAL_COLS(TOTAL_COLS),
            .TOTAL_ROWS(TOTAL_ROWS)
        ) inst_Sync_To_Count (
            .i_Clk       (clk),
            .i_HSync     (h_sync),
            .i_VSync     (v_sync),
            .o_Col_Count (col_counter),
            .o_Row_Count (row_counter)
        );

    draw_game_objects #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS)
        ) inst_draw_game_objects (
            .move_up_control_p0   (move_up_control_p0),
            .move_down_control_p0 (move_down_control_p0),
            .move_up_control_p1   (move_up_control_p1),
            .move_down_control_p1 (move_down_control_p1),
            .input select_l_paddle_player (select_l_paddle_player),
            .input select_r_paddle_player (select_r_paddle_player),
            .col_counter          (col_counter),
            .row_counter          (row_counter),
            .rgb                  (rgb),
            .clk                  (clk)
        );

    // Add FSM here

endmodule