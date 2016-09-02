// Draw a rectangle with the specified bounds. Color is specified with the
// 8-bit rgb parameter RECT_COLOR. 3 bits for red, 3 for green, 2 for blue.

module draw_rectangle
    #(
        parameter RECT_COLOR = 8'b11111111 // default white
    )
    (
        input [11:0] col_counter,
        input [11:0] row_counter,
        input [11:0] top_bound,
        input [11:0] bottom_bound,
        input [11:0] left_bound,
        input [11:0] right_bound,

        output reg [7:0] rgb,

        input clk
    );

    // Draw object in bounds
    always @(posedge clk) begin
        if (((left_bound < col_counter) && (col_counter < right_bound)) &&
             ((top_bound < row_counter) && (row_counter < bottom_bound)))
            rgb = RECT_COLOR;
        else
            rgb = 0;
    end
   
endmodule