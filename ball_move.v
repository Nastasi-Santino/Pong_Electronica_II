module ball_move(
    input  wire        clk,
    input  wire        rst,
    input  wire        move_tick,
    input  wire [6:0]  bottomPaddleX,
    input  wire [6:0]  topPaddleX,
    input  wire [6:0]  ballX,
    input  wire [5:0]  ballY,
    output reg  signed [2:0] dx,
    output reg  signed [2:0] dy
);

    localparam integer BALL_HALF   = 2;
    localparam integer PADDLE_HALF = 8;

    localparam [5:0] TOP_PADDLE_Y    = 6'd3;
    localparam [5:0] BOTTOM_PADDLE_Y = 6'd60;

    wire signed [7:0] bx  = $signed({1'b0, ballX});
    wire signed [7:0] by  = $signed({2'b0, ballY});
    wire signed [7:0] tpx = $signed({1'b0, topPaddleX});
    wire signed [7:0] bpx = $signed({1'b0, bottomPaddleX});

    wire signed [7:0] ball_left   = bx - BALL_HALF;
    wire signed [7:0] ball_right  = bx + BALL_HALF;
    wire signed [7:0] ball_top    = by - BALL_HALF;
    wire signed [7:0] ball_bottom = by + BALL_HALF;

    wire leftWallHit  = (ball_left  <= 0);
    wire rightWallHit = (ball_right >= 127);

    wire topPaddleHit =
        (ball_top <= TOP_PADDLE_Y + 1) &&
        (ball_right >= (tpx - PADDLE_HALF)) &&
        (ball_left  <= (tpx + PADDLE_HALF));

    wire bottomPaddleHit =
        (ball_bottom >= BOTTOM_PADDLE_Y - 1) &&
        (ball_right  >= (bpx - PADDLE_HALF)) &&
        (ball_left   <= (bpx + PADDLE_HALF));

    wire signed [7:0] offset_top    = bx - tpx;
    wire signed [7:0] offset_bottom = bx - bpx;

    function automatic signed [2:0] dx_from_offset(input signed [7:0] off);
    begin
        if (off <= -6)      dx_from_offset = -3'sd2;
        else if (off <= -2) dx_from_offset = -3'sd1;
        else if (off <=  1) dx_from_offset =  3'sd0;
        else if (off <=  5) dx_from_offset =  3'sd1;
        else                dx_from_offset =  3'sd2;
    end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            dx <= 3'sd0;
            dy <= -3'sd1;
        end else if (move_tick) begin

            // Rebote en paredes laterales
            if (leftWallHit || rightWallHit)
                dx <= -dx;

            // Rebote en paletas (solo si va hacia ellas)
            if (topPaddleHit && dy < 0) begin
                dy <= -dy;
                dx <= dx_from_offset(offset_top);
            end else if (bottomPaddleHit && dy > 0) begin
                dy <= -dy;
                dx <= dx_from_offset(offset_bottom);
            end
        end
    end

endmodule
