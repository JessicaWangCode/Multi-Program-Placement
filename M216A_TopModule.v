`timescale 1ns / 100ps

//Do NOT Modify This Module                     
module P1_Reg_8_bit (DataIn, DataOut, rst, clk);

    input [7:0] DataIn;
    output [7:0] DataOut;
    input rst;
    input clk;
    reg [7:0] DataReg;
   
    always @(posedge clk)
  	if(rst)
            DataReg <= 8'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

//Do NOT Modify This Module
module P1_Reg_5_bit (DataIn, DataOut, rst, clk);

    input [4:0] DataIn;
    output [4:0] DataOut;
    input rst;
    input clk;
    reg [4:0] DataReg;
    
    always @(posedge clk)
        if(rst)
            DataReg <= 5'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

//Do NOT Modify This Module
module P1_Reg_4_bit (DataIn, DataOut, rst, clk);

    input [3:0] DataIn;
    output [3:0] DataOut;
    input rst;
    input clk;
    reg [3:0] DataReg;
    
    always @(posedge clk)
        if(rst)
            DataReg <= 4'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

//Do NOT Modify This Module's I/O Definition
module M216A_TopModule(
    clk_i,
    width_i,
    height_i,
    index_x_o,
    index_y_o,
    strike_o,
    rst_i




   
);

input clk_i;
input [4:0] width_i;
input [4:0] height_i;
output [7:0] index_x_o;
output [7:0] index_y_o;
output [3:0] strike_o;
input rst_i;

wire clk_i;
wire [4:0] width_i;
wire [4:0] height_i;
wire rst_i;

//Add your code below 
//Make sure to Register the outputs using the Register modules given above






wire input_enable;
reg enable;

////////////////////////////////

wire [4:0] width_in_pre;
wire [4:0] height_in_pre;






wire [7:0] index_x;
wire [7:0] index_y;
wire [3:0] strike;



P1_Reg_5_bit INPUT_W_pre(
    .DataIn(width_i),
    .DataOut(width_in_pre),
    .rst(rst_i),
    .clk(clk_i)
);


P1_Reg_5_bit INPUT_H_pre(
    .DataIn(height_i),
    .DataOut(height_in_pre),
    .rst(rst_i),
    .clk(clk_i)
);






Processing_box black_box(
    .height_i(height_in_pre),
    .width_i(width_in_pre), 
    .clk_i(clk_i), 
    .rst_i(rst_i),
    .index_x_o(index_x),
    .index_y_o(index_y),
    .strike_o(strike),
    
    .input_enable(input_enable)
    
);


P1_Reg_8_bit OUTPUT_x1(
    .DataIn(index_x),
    .DataOut(index_x_o),
    .rst(rst_i),
    .clk(clk_i)
);




P1_Reg_8_bit OUTPUT_y1(
    .DataIn(index_y),
    .DataOut(index_y_o),
    .rst(rst_i),
    .clk(clk_i)
);








P1_Reg_4_bit OUTPUT_s1(
    .DataIn(strike),
    .DataOut(strike_o),
    .rst(rst_i),
    .clk(clk_i)
);





assign input_enable = enable;



 always @(posedge clk_i or posedge rst_i) begin
            if (rst_i) begin
             
                enable <= 0;
                
             end else begin
                if (height_in_pre != 0) begin
                        enable <= 1;
                       
                end
             end
        end





endmodule
