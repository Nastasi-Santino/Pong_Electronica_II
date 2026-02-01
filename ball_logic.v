module ball_logic #(
    parameter integer CLK_HZ  = 10_000_000,
    parameter integer MOVE_HZ = 100
)(
    input wire       clk,
    input wire       rst,
    input wire [6:0] firstPos,
    input wire [6:0] secondPos,
    output reg [6:0] ballX,
    output reg [5:0] ballY
);

    // Contador para la frecuencia de movimiento de la pelota
    localparam integer CUENTA = CLK_HZ / MOVE_HZ; // clocks por tick
    localparam integer CW = $clog2(CUENTA);
    reg [CW-1:0] cont;

    wire move_tick = (cont == CUENTA- 'd1);

    wire signed [2:0] dx;
    wire signed [2:0] dy;
    ball_move bm1 (
    .clk(clk),
    .rst(rst),
    .move_tick(move_tick),
    .bottomPaddleX(firstPos),
    .topPaddleX(secondPos),
    .ballX(ballX),
    .ballY(ballY),
    .dx(dx),
    .dy(dy)
    );

    wire signed [7:0] bX_ext = $signed({1'b0, ballX});
    wire signed [6:0] bY_ext = $signed({1'b0, ballY});
    wire signed [7:0] next_bX = bX_ext + dx;
    wire signed [6:0] next_bY = bY_ext + dy;

    always @(posedge clk) begin
    
        if(rst == 'd1) begin
            ballX <= 7'd64;
            ballY <= 6'd32;
            cont <= 'd0;
        end else begin

            if(cont < CUENTA - 'd1) begin
                cont <= cont + 'd1;
            end else begin
                ballX <= next_bX[6:0];
                ballY <= next_bY[5:0];
                cont <= 'd0;
            end

        end
        
    end


endmodule