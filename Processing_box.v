module Processing_box (
    height_i, 
    width_i, 
    clk_i, 
    rst_i,
    index_x_o,
    index_y_o,
    strike_o,

    
   
    input_enable,
   
    );


        function [3:0] get_strip_id(
        input [7:0] strip16_3, 
        input [7:0] strip16_2, 
        input [7:0] strip16_1
    );
    begin
        if (strip16_3 <= strip16_2 && strip16_3 <= strip16_1)
            get_strip_id = 4'b1100; // strip16_3 最小
        else if (strip16_2 < strip16_3 && strip16_2 <= strip16_1)
            get_strip_id = 4'b1011; // strip16_2 最小
        else
            get_strip_id = 4'b1010; // strip16_1 最小
    end
    endfunction





    input input_enable;
    input [4:0] height_i;
    input [4:0] width_i;
    input clk_i;
    input rst_i;
    output reg [7:0] index_x_o;
    output reg [7:0] index_y_o;
    output reg [3:0] strike_o;




    reg [7:0] strips [0:12]; // 定义一个数组存储 strip 值



    //比较strip时获取id
    reg [3:0] strip_id ;

    
    reg [7:0] index_x ;
    reg [7:0] index_y;
    reg [3:0] strike ;
   


    //输出使能
    reg enable;


    


    //State encoding
    reg [1:0] current_state, next_state;




    

    parameter  IDLE = 2'b00,
               Strip_Compare = 2'b01,
               Width_Update = 2'b10,
               Width_Check = 2'b11;
              
                

    //stripe选择state
    parameter  S4 = 5'b00100,
               S5 = 5'b00101,
               S6 = 5'b00110,
               S7 = 5'b00111,
               S8 = 5'b01000,
               S9 = 5'b01001,
               S10 = 5'b01010,
               S11 = 5'b01011,
               S12 = 5'b01100,
               S13 = 5'b01101,
               S14 = 5'b01110,
               S15 = 5'b01111,
               S16 = 5'b10000;
    

    //width更新状态选择
    parameter  Width_S1 = 4'b0001,
               Width_S2 = 4'b0010,
               Width_S3 = 4'b0011,
               Width_S4 = 4'b0100,
               Width_S5 = 4'b0101,
               Width_S6 = 4'b0110,
               Width_S7 = 4'b0111,
               Width_S8 = 4'b1000,
               Width_S9 = 4'b1001,
               Width_S10 = 4'b1010,
               Width_S11 = 4'b1011,
               Width_S12 = 4'b1100,
               Width_S13 = 4'b1101;

              
    


              // 定义 strip_y 数组，存储每个 strip 的 Y 坐标
    reg [7:0] strip_y [0:12];


    
    //strip左下角x坐标
    parameter strip1_x = 8'b00000000,
              strip2_x = 8'b00000000,
              strip3_x = 8'b00000000,
              strip4_x = 8'b00000000,
              strip5_x = 8'b00000000,
              strip6_x = 8'b00000000,
              strip7_x = 8'b00000000,
              strip8_x = 8'b00000000,
              strip9_x = 8'b00000000,
              strip10_x = 8'b00000000,
              strip11_x = 8'b00000000,
              strip12_x = 8'b00000000,
              strip13_x = 8'b00000000;




    reg [3:0] strip_id_map [0:11][0:1]; // 用于映射比较的两个 strips


    




    // State transition
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            current_state <= IDLE;
            
           strip_y[0] <= 8'b00000000;
            strip_y[1] <= 8'b00001000;
            strip_y[2] <= 8'b00010000;
            strip_y[3] <= 8'b00011001;
            strip_y[4] <= 8'b00100000;
            strip_y[5] <= 8'b00101010;
            strip_y[6] <= 8'b00110000;
            strip_y[7] <= 8'b00111011;
            strip_y[8] <= 8'b01000000;
            strip_y[9] <= 8'b01001100;
            strip_y[10] <= 8'b01010000;
            strip_y[11] <= 8'b01100000;
            strip_y[12] <= 8'b01110000;



            

            
        end else begin
            





            

        current_state <= next_state;
                
            
	    end
    end

     // Next state logic
    always @(*) begin


    if (input_enable != 1)begin
        next_state = IDLE;
         strike = 0;
           
             index_x = 0;
             index_y = 0;
            
             strip_id = 0;
            enable = 0;

         
        strips[0] = 0;
        strips[1] = 0;
        strips[2] = 0;
        strips[3] = 0;
        strips[4] = 0;
        strips[5] = 0;
        strips[6] = 0;
        strips[7] = 0;
        strips[8] = 0;
        strips[9] = 0;
        strips[10] = 0;
        strips[11] = 0;
        strips[12] = 0;



    end else begin


        case (current_state)//synopsys_parallel_case synopsys_full_case



            IDLE: begin
                
                enable = 1;
               
                

                next_state = Strip_Compare;
            end


            Strip_Compare: begin
                

                enable = 0;


                case (height_i)//synopsys_parallel_case synopsys_full_case
                    S4: begin  //输入高度为4
                         if (strips[9] <= strips[7]) begin
                             strip_id = 4'b1001;
                         end else begin
                             strip_id = 4'b0111;
                         end
                    end  
                    S5: begin
                         if (strips[7] <= strips[5]) begin
                             strip_id = 4'b0111;
                         end else begin
                             strip_id = 4'b0101;
                         end   
                    end
                    S6: begin
                         if (strips[5] <= strips[3]) begin
                             strip_id = 4'b0101;
                         end else begin
                             strip_id = 4'b0011;
                        end
                    end
                    S7: begin
                         if (strips[3] <= strips[0] && strips[3] <= strips[1]) begin
                            strip_id = 4'b0011;          // strip7 最小或与其他相等时，选择 strip7 的 ID
                         end else if (strips[0] < strips[3] && strips[0] <= strips[1]) begin
                            strip_id = 4'b0000;          // strip8_1 最小或与 strip8_2 相等时，选择 strip8_1 的 ID
                         end else begin
                            strip_id = 4'b0001; 
                         end         // strip8_2 最小时，选择 strip8_2 的 ID
                    end
                    S8: begin
                         if (strips[0] <= strips[1] && strips[0] <= strips[2]) begin
                             strip_id = 4'b0000;
                         end else if(strips[1] < strips[0] && strips[1] <= strips[2]) begin
                             strip_id = 4'b0001;
                         end else  begin
                             strip_id = 4'b0010;
                         end
                    end
                     S9: begin
                         if (strips[2] <= strips[4]) begin
                             strip_id = 4'b0010;
                         end else  begin
                             strip_id = 4'b0100;
                         end
                    end
                    S10: begin
                         if (strips[4] <= strips[6]) begin
                             strip_id = 4'b0100;
                         end else  begin
                             strip_id = 4'b0110;
                         end
                    end
                    S11: begin
                         if (strips[6] <= strips[8]) begin
                             strip_id = 4'b0110;
                         end else  begin
                             strip_id = 4'b1000;
                         end
                    end
                    S12: begin
                             strip_id = 4'b1000;
                    end
                     S13: begin
                        
                        strip_id = get_strip_id(strips[12], strips[11], strips[10]);
                    end
                    S14: begin
                        
                        strip_id = get_strip_id(strips[12], strips[11], strips[10]);
                    end
                    S15: begin
                       
                        strip_id = get_strip_id(strips[12], strips[11], strips[10]);
                    end
                    S16: begin
                        
                        strip_id = get_strip_id(strips[12], strips[11], strips[10]);
                    end
                endcase

            
                next_state = Width_Update;

         
            end



            Width_Update: begin
                index_x = strips[strip_id];
                strips[strip_id] = strips[strip_id] + {3'b000, width_i};
               
                next_state = Width_Check;


            end



           Width_Check: begin

                    
                    if (strips[strip_id] <= 8'b10000000) begin
                            
                            index_y = strip_y[strip_id] ;
                            
                        end else begin
                            index_x = 8'b10000000;
                            index_y = 8'b10000000 ;
                           strike = strike + 1;
                        end





                
                next_state = IDLE;
                

                

                
            end


            
    
        endcase

    end

    end

    always @(posedge clk_i or posedge rst_i) begin
            if (rst_i) begin
             
                index_x_o <= 0;
                index_y_o <= 0;
                strike_o <= 0;
                
             end else begin
                if (enable == 1) begin
                        index_x_o <= index_x;
                        index_y_o <= index_y;
                        strike_o <= strike;
                       
                end
             end
        end

        

    
endmodule