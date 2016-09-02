/* TO DO: x, y velocity to alter angle of ball direction depending on where it hits paddle */

// Move ball in 1 of 4 diagnol directions and change direction when colliding
// with objects
module move_ball
    #(
        parameter DISP_COLS           = 800,
        parameter DISP_ROWS           = 600,
        parameter P_HEIGHT            = 44,
        parameter P_WIDTH             = 12,
        parameter B_HEIGHT            = 8,
        parameter B_WIDTH             = 6,
        parameter L_PADDLE_CENTER_COL = 15,
        parameter R_PADDLE_CENTER_COL = DISP_COLS - 15
    )
    (
        input [11:0] l_center_row, // center row of left and right paddles
        input [11:0] r_center_row,
        output reg [11:0] ball_center_col = DISP_COLS/2,
        output reg [11:0] ball_center_row = DISP_ROWS/2
        ,

        input clk
    );

    parameter UP_LEFT    = 2'b00;  // define directions
    parameter DOWN_LEFT  = 2'b01;
    parameter UP_RIGHT   = 2'b10;
    parameter DOWN_RIGHT = 2'b11;

    parameter SCALER = 300000;

    reg [1:0] ball_direction = UP_RIGHT;

    clock_scaler #(.SCALER_WIDTH(20))
        inst_clock_scaler (
            .clk        (clk),
            .scaler     (SCALER),
            .slower_clk (slower_clk)
        );

    // Detect collisions
    always@ (posedge clk) begin
        if (ball_center_row - B_HEIGHT/2 <= 2) begin
            if (ball_direction == UP_LEFT)
                ball_direction = DOWN_LEFT;
            if (ball_center_col == UP_RIGHT)
                ball_direction = DOWN_RIGHT;
        end
          
        else if (ball_center_row + B_HEIGHT/2 >= DISP_ROWS - 46) begin
            if (ball_direction == DOWN_LEFT)
                ball_direction = UP_LEFT;
            if (ball_center_col == DOWN_RIGHT)
                ball_direction = UP_RIGHT;
        end
            
        else if (ball_center_col - B_HEIGHT/2 <= 2) begin
            if (ball_direction == UP_LEFT)
                ball_direction = UP_RIGHT;
            if (ball_center_col == DOWN_LEFT)
                ball_direction = DOWN_RIGHT;
        end

        else if (ball_center_col + B_HEIGHT/2 >= DISP_COLS - 2) begin
            if (ball_direction == UP_RIGHT)
                ball_direction = UP_LEFT;
            if (ball_center_col == DOWN_RIGHT)
                ball_direction = DOWN_LEFT;
        end

       /* else if ( (ball_center_col - B_WIDTH/2 == L_PADDLE_CENTER_COL + P_WIDTH/2) &&
             (ball_center_row + B_HEIGHT/2 >= l_center_row - P_HEIGHT/2  &&
              ball_center_row - B_HEIGHT/2 <= l_center_row + P_HEIGHT/2) )
            collision_type = L_PADDLE_COLLIS;

        else if ( (ball_center_col + B_WIDTH/2 == R_PADDLE_CENTER_COL - P_WIDTH/2) &&
             (ball_center_row + B_HEIGHT/2 >= l_center_row - P_HEIGHT/2  &&
              ball_center_row - B_HEIGHT/2 <= l_center_row + P_HEIGHT/2) )
            collision_type = R_PADDLE_COLLIS;
            */

        else
            ball_direction = ball_direction;

    end

    // Move ball
    always @(posedge slower_clk) begin
        case(ball_direction)
        UP_LEFT: begin
            ball_center_col = ball_center_col - 1;
            ball_center_row = ball_center_row - 1;
        end
        DOWN_LEFT: begin
            ball_center_col = ball_center_col - 1;
            ball_center_row = ball_center_row + 1;
        end
        UP_RIGHT: begin
            ball_center_col = ball_center_col + 1;
            ball_center_row = ball_center_row - 1;
        end
        DOWN_RIGHT: begin
            ball_center_col = ball_center_col + 1;
            ball_center_row = ball_center_row + 1;
        end
        endcase
    end

endmodule