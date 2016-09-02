/* 
    Add front and back porch to h_sync and v_sync signals
*/

module add_porch 
    #(
        parameter TOTAL_COLS  = 800,
        parameter TOTAL_ROWS  = 525,
        parameter DISP_COLS = 640,
        parameter DISP_ROWS = 480
    ) 
    (
        input h_sync_without_porch,
        input v_sync_without_porch,

        output reg h_sync_with_porch,
        output reg v_sync_with_porch,

        input clk
    );

    // 72 Hz
    
    parameter V_FRONT_PORCH = 37;
    parameter V_BACK_PORCH  = 23;
    parameter H_FRONT_PORCH = 56;
    parameter H_BACK_PORCH  = 64;
    

    /* 75 Hz
    parameter V_FRONT_PORCH = 1;
    parameter V_BACK_PORCH  = 21;
    parameter H_FRONT_PORCH = 16;
    parameter H_BACK_PORCH  = 180;
    */

    wire temp_h_sync;
    wire temp_v_sync;
    wire [11:0] col_counter;
    wire [11:0] row_counter;

    Sync_To_Count #(
            .TOTAL_COLS(TOTAL_COLS),
            .TOTAL_ROWS(TOTAL_ROWS)
        ) inst_Sync_To_Count (
            .i_Clk       (clk),
            .i_HSync     (h_sync_without_porch),
            .i_VSync     (v_sync_without_porch),
            .o_HSync     (temp_h_sync),
            .o_VSync     (temp_v_sync),
            .o_Col_Count (col_counter),
            .o_Row_Count (row_counter)
        );

    always @(posedge clk) begin
        if ( (col_counter < DISP_COLS + H_FRONT_PORCH) || 
             (col_counter > (TOTAL_COLS - H_BACK_PORCH - 1) )) begin
            h_sync_with_porch <= 1;
        end
        else begin
            h_sync_with_porch <= temp_h_sync;
        end

        if ( (row_counter < DISP_ROWS + V_FRONT_PORCH) || 
             (row_counter > (TOTAL_ROWS - V_BACK_PORCH - 1) )) begin
            v_sync_with_porch <= 1;
        end
        else begin
            v_sync_with_porch <= temp_v_sync;
        end
    end 

endmodule