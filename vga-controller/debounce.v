/*=============================================================================
 * This document contains information proprietary to the CSULB student that 
   created the file - any reuse without adequate approval and documentation is 
   prohibited. 
 * Class:      CECS 360 - Integrated Circuit Design Software 
 * File Name:  debounce.v
 * Project:    Counter w/ Display
 * Designer:   Michael Rios - Copyright © 2017. All rights reserved. 
 * Email:      riosmichael28@ymail.com
 * Rev. Date:  September 17, 2017
 *
 * Description: Major ideas for this debouncing technique was taken from:
                Chu, Pong P. (1959) FPGA Prototyping by Verilog Examples
                This module debounces the mechanical pushbuttons on the board. 
                Using the fact that signals typically settle within 20ms, this 
                module uses a one clock wide pulse every 10ms and a FSM to 
                ensure that the output of this module is released only after 
                the input has been stabalized for at least 20ms. 
 *         
 * In submitting this file for class work at CSULB, I am confirming that this 
   is my work and the work of no one else. 
 * 
 * In the event other code sources are utilized I will document which portion 
   of the code and who is the author. 
 *
 * In submitting this code I acknowledge that plagiarism in student project 
   work is subject to dismissal from the class. 
 *===========================================================================*/ 
 `timescale 1ns / 1ps
 
module debounce(clk, reset, sw, db);
   
   input       clk, reset, sw; 
   output reg  db; 
   
   // State Declaration: 
   localparam [2:0] 
               zero     = 3'b000, 
               wait1_1  = 3'b001,
               wait1_2  = 3'b010, 
               wait1_3  = 3'b011, 
               one      = 3'b100, 
               wait0_1  = 3'b101, 
               wait0_2  = 3'b110, 
               wait0_3  = 3'b111; 
               
   // Signal Declaration: 
   reg [2:0] state_reg, state_next; 
         
         
   // ==================================
   // Generating 10ms tick
   // ==================================
   
   // Signal Declaration
   wire tick; 
   reg [19:0] count; 
   
   assign tick = (count == 999999) ? 1'b1: 1'b0; 
   
   always @ (posedge clk, posedge reset) 
         if(reset)
            count <= 20'b0; 
         else if (tick)
            count <= 20'b0; 
         else 
            count <= count + 20'b1;
         
   // ==================================
   // Debouncing FSM
   // ==================================
   
   //state register
   always @ (posedge clk, posedge reset)
      if(reset) 
         state_reg <= zero; 
      else 
         state_reg <= state_next; 
    
   //next state logic
   always @ (*) 
   begin 
      state_next = state_reg; // default state: the same 
      db = 1'b0;               // default output: 0
      case (state_reg)
         zero:    if (sw) state_next = wait1_1; 
         
         wait1_1: if (~sw) state_next = zero;
                  else if (tick) state_next = wait1_2; 
                   
         wait1_2: if (~sw) state_next = zero; 
                  else if (tick) state_next = wait1_3; 
                  
         wait1_3: if (~sw) state_next = zero;
                  else if (tick) state_next = one;
                  
         one: begin 
                  db = 1'b1; 
                  if (~sw) state_next = wait0_1; 
              end
              
         wait0_1: begin 
                     db = 1'b1; 
                     if (sw) state_next = one;
                     else if (tick) state_next = wait0_2; 
                  end 
                  
         wait0_2: begin 
                     db = 1'b1; 
                     if (sw) state_next = one; 
                     else if (tick) state_next = wait0_3; 
                  end 
                  
         wait0_3: begin 
                     db = 1'b1; 
                     if (sw) state_next = one; 
                     else if (tick) state_next = zero; 
                  end
         default: state_next = zero; 
      endcase
   end
            
   
endmodule