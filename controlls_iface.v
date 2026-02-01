module controlls_iface (
    input wire          clk,
    input wire          rst,
    input wire [1:0]    btns,
    output reg          btn_pressed,
    output reg [1:0]    btn_stored
);

    localparam integer CUENTA = 10000;
    localparam integer CW = $clog2(CUENTA + 1);
    
    reg [CW-1:0] cont;
    reg [1:0]    btn_prev;

    always @(posedge  clk) begin
    
        if(rst == 'd1) begin
            cont        <= 'd0;   
            btn_stored   <= 2'd0;
            btn_pressed <= 1'b0;
            btn_prev <= 'd0;


        end else begin
            if(btns != btn_prev) begin
                btn_prev <= btns;
                cont <= 'd0;

            end else if(|btns) begin

                if(cont < CUENTA[CW-1:0]) begin
                    cont <= cont + 1'b1;
                end

                if((cont >= CUENTA[CW-1:0])) begin
                    btn_stored <= btns; 
                end 

            end else begin 
                cont <= 'd0;
                btn_stored <= 'd0;
            end

            btn_pressed <= (btn_stored != 2'b00);
        
        end

    end


endmodule