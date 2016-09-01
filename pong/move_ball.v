// Move ball in 1 of 4 diagnol directions
module move_ball
    #(
        parameter DISP_COLS     = 800,
        parameter DISP_ROWS     = 600
    )
    (
        input [1:0] ball_direction,
        input [1:0] collision_type,

        output [11:0] ball_center_col = DISP_COLS / 2,
        output [11:0] ball_center_row = DISP_ROWS / 2,

        input clk
    );

    parameter UP_LEFT    = 2'b00;  // define directions
    parameter DOWN_LEFT  = 2'b01;
    parameter UP_RIGHT   = 2'b10;
    parameter DOWN_RIGHT = 2'b11;

    parameter NO_COLLIS         = 3'b000;  // define collision types
    parameter L_PADDLE_COLLIS   = 3'b001;  
    parameter R_PADDLE_COLLIS   = 3'b010;
    parameter TOP_COLLIS        = 3'b011;
    parameter BOTTOM_COLLIS     = 3'b100;

    clock_scaler #(
            .SCALER_WIDTH(SCALER_WIDTH)
        ) inst_clock_scaler (
            .clk        (clk),
            .scaler     (scaler),
            .slower_clk (slower_clk)
        );

    always @(posedge clk) begin
        case(collision_type)
        NO_COLLIS: 
        L_PADDLE_COLLIS:
            if(ball_direction == UP_LEFT)




    end

    always @(posedge slower_clk) begin
        case(ball_direction)
        UP_LEFT: 
            ball_center_col =  ball_center_col - 1;
            ball_center_row =  ball_center_row - 1;
        DOWN_LEFT:
            ball_center_col =  ball_center_col - 1;
            ball_center_row =  ball_center_row + 1;
        UP_RIGHT:
            ball_center_col =  ball_center_col + 1;
            ball_center_row =  ball_center_row - 1;
        DOWN_RIGHT:
            ball_center_col =  ball_center_col + 1;
            ball_center_row =  ball_center_row + 1;
        endcase
    end

endmodule