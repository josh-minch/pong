###Pong

An unfinished implementation of Pong and an accompanying VGA controller built
with Verilog, tested to work on the Digilent BASYS2 FPGA board.

Game and control details:

Use the first two switches to select if the paddles are person or AI controlled
and move the paddles up and down with the four buttons. Scores for each player
are displayed on the 7-segment display. Last switch activates lulz-mode.

Module Hierarchy:

    vga_top
    |---generate_sync_pulses
    |---pong
    |   |---draw_game_objects
    |   |   |---draw_paddle
    |   |   |       draw_rectangle
    |   |   |---draw_ball
    |   |   |       draw_rectangle
    |   |   |       move_ball
    |   |   |---player_move_paddle
    |   |   |---ai_move_paddle
    |   |---sync_to_count   
    ----add_porch

Device and specification details:

The constraint file cons.ucf is for the Xilinx Spartan 3E-100 CP132 FPGA. The
input clock used is the default 50 Mhz one. Its designed to display a
resolution of 800 x 600 @ 72 Hz, but with a faster clock speed and slight
modification of the code's parameters it can display higher.

ISE Project Navigator was used to synthesize the verilog code, implement
the design, and generate the programming file. The programming file was then
programmed to the device with Adept. All software is free and can be found
online.