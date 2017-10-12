/*=============================================================================
 * This document contains information proprietary to the CSULB student that 
   created the file - any reuse without adequate approval and documentation is 
   prohibited. 
 * Class:      CECS 360 - Integrated Circuit Design Software 
 * File Name:  aiso_rst.v
 * Project:    Counter w/ Display
 * Designer:   Michael Rios - Copyright © 2017. All rights reserved. 
 * Email:      riosmichael28@ymail.com
 * Rev. Date:  September 17, 2017
 *
 * Description: This module models a circuit which takes an asynchronous input, 
                in this case coming from the reset button, and outputs a 
                synchronous signal.  This is achieved through the use of 
                a synchronous flop called 'delay_reg'. Synchronous resets will 
                only reset the state of flops in the system on the active edge 
                of the clock.
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

module aiso_rst(clk, reset, reset_s);

   input    clk, reset; 
   output   reset_s; 
   reg      delay_reg, synch_reg; 
   
   always @ (posedge clk, posedge reset) 
      if (reset) 
         {delay_reg, synch_reg} <= {1'b0, 1'b0};
         
      else // synchronize the output
         {delay_reg, synch_reg} <= {1'b1, delay_reg};
         
   assign reset_s = ~synch_reg; //make the reset HIGH active


endmodule
