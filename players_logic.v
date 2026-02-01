module players_logic #(
    parameter integer CLK_HZ  = 10_000_000,
    parameter integer MOVE_HZ = 100
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  btns,
    output reg  [6:0]  position
);

    wire signed [2:0] dx;
    limited_move lm1 (
    .rst(rst),
    .actual_pos(position),
    .isLeft(btns[0]),
    .isRight(btns[1]),
    .dx(dx)
    );

    // Contador para la frecuencia de movimiento del jugador
    localparam integer CUENTA = CLK_HZ / MOVE_HZ; // clocks por tick
    localparam integer CW = $clog2(CUENTA);
    reg [CW-1:0] cont;

    // suma segura (signed) con 1 bit extra
    wire signed [7:0] pos_ext  = $signed({1'b0, position});
    wire signed [7:0] next_pos = pos_ext + dx;

    always @(posedge clk) begin
    
        if(rst == 'd1) begin
            position <= 7'd64;
            cont <= 'd0;
        end else begin

            if(cont < CUENTA - 'd1) begin
                cont <= cont + 'd1;
            end else begin
                position <= next_pos[6:0];
                cont <= 'd0;
            end

        end
        
    end


endmodule