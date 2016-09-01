// Added sync_to_count and it broke stuff. Before I passed row and col
// counters straight to draw and porch, now I used sync to count

module vga_top
    ( 
        input move_up_control_p0,   // left paddle move controls
        input move_down_control_p0,
        input move_up_control_p1,   // right paddle move controls
        input move_down_control_p1,

        output v_sync_with_porch,
        output h_sync_with_porch,
        output [7:0] rgb,

        input clk     
    );

    // Number of active columns and rows actually displayed on screen
    parameter DISP_COLS = 800;
    parameter DISP_ROWS = 600;

    // Amount of total cols and rows. Total = display + blank. 
    // Blank cols and rows come from front and back porch and sync pulse
    parameter TOTAL_COLS  = 1040; 
    parameter TOTAL_ROWS  = 666;
	 
    parameter RED = 3'b111;
    parameter GRN = 3'b000;
    parameter BLU = 2'b00;

    create_sync_pulses #(
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS),
            .TOTAL_COLS(TOTAL_COLS),
            .TOTAL_ROWS(TOTAL_ROWS)
        ) inst_create_sync_pulses (
            .v_sync (v_sync),
            .h_sync (h_sync),
            .clk    (clk)
        );

    pong #(
            .TOTAL_COLS(TOTAL_COLS),
            .TOTAL_ROWS(TOTAL_ROWS),
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS)
        ) inst_pong (
            .move_up_control_p0   (move_up_control_p0),
            .move_down_control_p0 (move_down_control_p0),
            .move_up_control_p1   (move_up_control_p1),
            .move_down_control_p1 (move_down_control_p1),
            .h_sync               (h_sync),
            .v_sync               (v_sync),
            .rgb                  (rgb),
            .clk                  (clk)
        );


    add_porch #(
            .TOTAL_COLS(TOTAL_COLS),
            .TOTAL_ROWS(TOTAL_ROWS),
            .DISP_COLS(DISP_COLS),
            .DISP_ROWS(DISP_ROWS)
        ) inst_add_porch (
            .h_sync_without_porch(h_sync),
            .v_sync_without_porch(v_sync),
            .h_sync_with_porch (h_sync_with_porch),
            .v_sync_with_porch (v_sync_with_porch),
            .clk               (clk)
        );

endmodule
