`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:40:26 06/23/2024 
// Design Name: 
// Module Name:    proj01 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module proj01(
    input wire clk,
    input wire reset,
    input wire [15:0] floor_request,
    input wire [15:0] elevator1_buttons_up,
    input wire [15:0] elevator1_buttons_down,
    input wire [15:0] elevator2_buttons_up,
    input wire [15:0] elevator2_buttons_down,
    output wire [2:0] elevator1_position,//stop=0,up=1,down=2;
    output wire [2:0] elevator2_position,
    output wire [2:0] elevator1_display,
    output wire [2:0] elevator2_display
);
    reg [2:0] state1;//we are using this to recive motor position
    reg [2:0] state2;
    reg [15:0] elevator1_target_floor;
    reg [15:0] elevator1_current_floor;
    reg [15:0] elevator2_target_floor;
    reg [15:0] elevator2_current_floor;
	 integer z;
	 reg clk_out;
	 integer z2;
	 reg clk_out2;
	 integer z3;
	 reg clk_out3;
	 always@(negedge clk)//clk_out for stop 5s
		begin
		if(reset==1)
		begin
		z<=0;
		clk_out<=0;
		end
		else 
		begin
		if(z==500000)
		begin
		clk_out <= ~clk_out;
		z<=0;
		end
		else 
		z <= z+1;
		end
		end //clk_out for stop 5s
		
		always@(negedge clk)//clk_out2 for elevator1 speed per floor
		begin
		if(reset==1)
		begin
		z2<=0;
		clk_out2<=0;
		end
		else 
		begin
		if(z2==200000)
		begin
		clk_out2 <= ~clk_out2;
		z2<=0;
		end
		else 
		z2 <= z2+1;
		end
		end //clk_out2
		
		always@(negedge clk)//clk_out3 for elevator2 speed per floor
		begin
		if(reset==1)
		begin
		z3<=0;
		clk_out3<=0;
		end
		else 
		begin
		if(z3==300000)
		begin
		clk_out3 <= ~clk_out3;
		z3<=0;
		end
		else 
		z3 <= z3+1;
		end
		end //clk_out3

    always @(posedge clk or posedge reset) begin //logic of controling elevator
        if (reset) begin
            state1 <= 3'b000;
            state2 <= 3'b000;
            elevator1_target_floor <= 16'b0;
            elevator1_current_floor <= 16'b0000000000000000;
            elevator2_target_floor <= 16'b0;
            elevator2_current_floor <= 16'b0000000000000001;
        end else begin

        if (elevator1_buttons_up) begin //request for going up for elevator number one
            case (state1)
                0: begin
                    if ((elevator1_buttons_up % 2 == 0) && (clk_out)) begin
                        elevator1_target_floor <= elevator1_buttons_up;
                        if (elevator1_current_floor < elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor + 2;
                        state1 <= 1;
								if (elevator1_buttons_up == elevator1_current_floor)
                        state1 <= 0;
                    end
                end
                1: begin
                    if ((elevator1_buttons_up) % 2 == 0 && (clk_out2)) begin
                        elevator1_target_floor <= elevator1_buttons_up;
                        if (elevator1_current_floor < elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor + 2;
                        else
                            state1 <= 2;
                    end
                end
                2: begin
                    if ((elevator1_buttons_up % 2 == 0) && (clk_out2)) begin
                        elevator1_target_floor <= elevator1_buttons_up;
                        if (elevator1_current_floor > elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor - 2;
                        else
                            state1 <= 0;
                    end
                end
            endcase

        end

        if (elevator1_buttons_down) begin //request for going down for elevator number one
            case (state1)
                0: begin
                    if ((elevator1_buttons_down % 2 == 0) && (clk_out)) begin
                        elevator1_target_floor <= elevator1_buttons_down;
                        if (elevator1_current_floor < elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor + 2;
                        state1 <= 1;
								if (elevator1_buttons_down == elevator1_current_floor)
                        state1 <= 0;
                    end
                end
                1: begin
                    if ((elevator1_buttons_down) % 2 == 0 && (clk_out2)) begin
                        elevator1_target_floor <= elevator1_buttons_down;
                        if (elevator1_current_floor < elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor + 2;
                        else
                            state1 <= 2;
                    end
                end
                2: begin
                    if ((elevator1_buttons_down % 2 == 0) && (clk_out2)) begin
                        elevator1_target_floor <= elevator1_buttons_down;
                        if (elevator1_current_floor > elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor - 2;
                        else
                            state1 <= 0;
                    end
                end
            endcase
        end

        if (elevator2_buttons_down) begin //request for going down for elevator number 2
            case (state2)
                0: begin
                    if ((elevator2_buttons_down % 2 != 0) && (clk_out)) begin
                        elevator2_target_floor <= elevator2_buttons_down;
                        if (elevator2_current_floor < elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor + 2;
                        state2 <= 1;
								if (elevator2_buttons_down == elevator2_current_floor)
                        state2 <= 0;
                    end
                end
                1: begin
                    if ((elevator2_buttons_down % 2 != 0) && (clk_out3)) begin
                        elevator2_target_floor <= elevator2_buttons_down;
                        if (elevator2_current_floor < elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor + 2;
                        else
                            state2 <= 2;
                    end
                end
                2: begin
                    if ((elevator2_buttons_down % 2 != 0) && (clk_out3)) begin
                        if (elevator2_current_floor > elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor - 2;
                        else
                            state2 <= 0;
                    end
                end
            endcase
        end

        if (elevator2_buttons_up) begin //request for going up for elevator number 2
            case (state2)
                0: begin
                    if ((elevator2_buttons_up % 2 != 0) && (clk_out)) begin
                        elevator2_target_floor <= elevator2_buttons_up;
                        if (elevator2_current_floor < elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor + 2;
                        state2 <= 1;
								if (elevator2_buttons_up == elevator2_current_floor)
                        state2 <= 0;
                    end
                end
                1: begin
                    if ((elevator2_buttons_up % 2 != 0) && (clk_out3)) begin
                        elevator2_target_floor <= elevator2_buttons_up;
                        if (elevator2_current_floor < elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor + 2;
                        else
                            state2 <= 2;
                    end
                end
                2: begin
                    if ((elevator2_buttons_up % 2 != 0) && (clk_out3)) begin
                        if (elevator2_current_floor > elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor - 2;
                        else
                            state2 <= 0;
                    end
                end
            endcase
        end

        if (floor_request) begin //request for moving between floors
            case (state1)
                0: begin
                    if ((floor_request % 2 == 0) && (clk_out)) begin
                        elevator1_target_floor <= floor_request;
                        if (elevator1_current_floor < elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor + 2;
                        state1 <= 1;
								if (floor_request == elevator1_current_floor)
                        state1 <= 0;
                    end
                end
                1: begin
                    if ((floor_request) % 2 == 0 && (clk_out2)) begin
                        elevator1_target_floor <= floor_request;
                        if (elevator1_current_floor < elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor + 2;
                        else
                            state1 <= 2;
                    end
                end
                2: begin
                    if ((floor_request % 2 == 0) && (clk_out2)) begin
                        elevator1_target_floor <= floor_request;
                        if (elevator1_current_floor > elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor - 2;
                        else
                            state1 <= 0;
                    end
                end
            endcase

            case (state2)
                0: begin
                    if ((floor_request % 2 != 0) && (clk_out)) begin
                        elevator2_target_floor <= floor_request;
                        if (elevator2_current_floor < elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor + 2;
                        state2 <= 1;
								if (floor_request == elevator2_current_floor)
                        state2 <= 0;
                    end
                end
                1: begin
                    if ((floor_request % 2 != 0) && (clk_out3)) begin
                        elevator2_target_floor <= floor_request;
                        if (elevator2_current_floor < elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor + 2;
                        else
                            state2 <= 2;
                    end
                end
                2: begin
                    if ((floor_request % 2 != 0) && (clk_out3)) begin
                        if (elevator2_current_floor > elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor - 2;
                        else
                            state2 <= 0;
                    end
                end
            endcase
        end
        end
    end
	 //disply of two seg for showing floor
	 assign {g2, f2, e2, d2, c2, b2, a2, g, f, e, d, c, b, a} =
        (floor_request == 0) ? 14'b00000010000001 :
        (floor_request == 1) ? 14'b00000011001111 :
        (floor_request == 2) ? 14'b00000010010010 :
        (floor_request == 3) ? 14'b00000010000110 :
        (floor_request == 4) ? 14'b00000011001100 :
        (floor_request == 5) ? 14'b00000010100100 :
        (floor_request == 6) ? 14'b00000010100000 :
        (floor_request == 7) ? 14'b00000010001111 :
        (floor_request == 8) ? 14'b00000010000000 :
        (floor_request == 9) ? 14'b00000010000100 :
        (floor_request == 10) ? 14'b10011110000001 :
        (floor_request == 11) ? 14'b10011111001111 :
        (floor_request == 12) ? 14'b10011110010010 :
        (floor_request == 13) ? 14'b10011110000110 :
        (floor_request == 14) ? 14'b10011111001100 :
        (floor_request == 15) ? 14'b10011110100100 :
        14'b111111111111111;
    assign elevator1_position = state1;
    assign elevator2_position = state2;
endmodule

        /*case (floor_request) 
            0 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000010000001;
            1 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000011001111;
            2 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000010010010;
            3 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000010000110;
            4 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000011001100;
            5 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000010100100;
            6 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000010100000;
            7 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000010001111;
            8 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000010000000;
            9 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b00000010000100;
            10 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b10011110000001;
            11 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b10011111001111;
            12 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b10011110010010;
            13 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b10011110000110;
            14 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b10011111001100;
            15 : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b10011110100100;
            
            default : (g2, f2, e2, d2, c2, b2, a2, g,f,e,d,c,b,a) = 14'b111111111111111;
        endcase*/
	/*/stop
	
	always @(posedge clk_out or posedge reset) begin
        if (reset) begin
            state1 <= 3'b000;
            state2 <= 3'b000;
            elevator1_target_floor <= 16'b0;
            elevator1_current_floor <= 16'b0;
            elevator2_target_floor <= 16'b0;
            elevator2_current_floor <= 16'b0;
        end else begin
            case (state1)
                0: begin
                    if (floor_request % 2 == 0) begin
                        elevator1_target_floor <= floor_request;
                        if (elevator1_current_floor < elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor + 1;
                        state1 <= 1;
								if (floor_request == elevator1_current_floor)
                        state1 <= 0;
                    end
                end
					 1: begin
					 end
					 2:begin
					 end
            endcase

            case (state2)
                0: begin
                    if (floor_request % 2 != 0) begin
                        elevator2_target_floor <= floor_request;
                        if (elevator2_current_floor < elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor + 1;
                        state2 <= 1;
								if (floor_request == elevator2_current_floor)
                        state2 <= 0;
                    end
                end
					 1: begin
					 end
					 2:begin
					 end
            endcase
        end
    end
	
	//stop*/
	
	/*/speed 2s
	always @(posedge clk_out2 or posedge reset) begin
        if (reset) begin
            state1 <= 3'b000;
            state2 <= 3'b000;
            elevator1_target_floor <= 16'b0;
            elevator1_current_floor <= 16'b0;
            elevator2_target_floor <= 16'b0;
            elevator2_current_floor <= 16'b0;
        end else begin
            case (state1)
                1: begin
                    if (floor_request % 2 == 0) begin
                        elevator1_target_floor <= floor_request;
                        if (elevator1_current_floor < elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor + 1;
                        else
                            state1 <= 2;
                    end
                end
                2: begin
                    if (floor_request % 2 == 0) begin
                        elevator1_target_floor <= floor_request;
                        if (elevator1_current_floor > elevator1_target_floor)
                            elevator1_current_floor <= elevator1_current_floor - 1;
                        else
                            state1 <= 0;
                    end
                end
            endcase
        end
    end
	//speed 2s
	//speed 3s
	always @(posedge clk_out3 or posedge reset) begin
        if (reset) begin
            state1 <= 3'b000;
            state2 <= 3'b000;
            elevator1_target_floor <= 16'b0;
            elevator1_current_floor <= 16'b0;
            elevator2_target_floor <= 16'b0;
            elevator2_current_floor <= 16'b0;
        end else begin
            case (state2)
                1: begin
                    if (floor_request % 2 != 0) begin
                        elevator2_target_floor <= floor_request;
                        if (elevator2_current_floor < elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor + 1;
                        else
                            state2 <= 2;
                    end
                end
                2: begin
                    if (floor_request % 2 != 0) begin
                        if (elevator2_current_floor > elevator2_target_floor)
                            elevator2_current_floor <= elevator2_current_floor - 1;
                        else
                            state2 <= 0;
                    end
                end
            endcase
        end
    end*/
	//speed 3s
	 