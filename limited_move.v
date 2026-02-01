module limited_move(
    input  wire              rst,
    input  wire [6:0]        actual_pos,
    input  wire              isLeft,
    input  wire              isRight,
    output reg signed [2:0] dx
);

    localparam integer WIDTH = 17;
    localparam integer HALF  = WIDTH/2;      
    localparam [6:0]   HALF7 = HALF[6:0];

    always @* begin
        dx = 3'sd0;  // default

        if (rst == 'd0) begin
            if (isLeft == 'd1 && isRight == 'd0) begin
                if (actual_pos > HALF7)
                    dx = -3'sd1;  
            end else if (isRight == 'd1 && isLeft == 'd0) begin
                if (actual_pos < (7'd127 - HALF7))
                    dx = 3'sd1;  
            end
        end
    end

endmodule