/* 
    Creates video signal by writing values to red, green, and blue signals
*/

module video_signal_generator
    #(
        parameter DISP_COLS = 640,
        parameter DISP_ROWS = 480
    )
    (
        input btn,
        input [11:0] col_counter,
        input [11:0] row_counter,

        output reg [2:0] red,
        output reg [2:0] grn,
        output reg [1:0] blu,

        input clk
    );

    reg prev_btn_status = 0;
    reg [4:0] video_selector = 0;

    always @(posedge clk) begin
        prev_btn_status <= btn;
            
        if (btn == 1 && prev_btn_status == 1) begin

            if (video_selector == 6) begin
                video_selector = 0;
            end

            else begin
                video_selector = video_selector + 1;
            end
        end
    end

    always @(posedge clk) begin
        if (col_counter < DISP_COLS && row_counter < DISP_ROWS) begin
            if (video_selector == 0) begin
                red <= 3'b111;
                grn <= 3'b111;
                blu <= 2'b00; 
            end
            else if (video_selector == 1) begin
                red <= 3'b111;
                grn <= 3'b000;
                blu <= 2'b11; 
            end
            else if (video_selector == 2) begin
                red <= 3'b000;
                grn <= 3'b111;
                blu <= 2'b11; 
            end
            else if (video_selector == 3) begin
                red <= 3'b111;
                grn <= 3'b111;
                blu <= 2'b11; 
            end
            else if (video_selector == 4) begin
                red <= 3'b100;
                grn <= 3'b100;
                blu <= 2'b00; 
            end
            else if (video_selector == 5) begin
                red <= 3'b100;
                grn <= 3'b000;
                blu <= 2'b10; 
            end
            else if (video_selector == 6) begin
                red <= 3'b000;
                grn <= 3'b100;
                blu <= 2'b10; 
            end
        end
        else begin
            red <= 3'b000;
            grn <= 3'b000;
            blu <= 2'b00;
        end
    end
   
endmodule