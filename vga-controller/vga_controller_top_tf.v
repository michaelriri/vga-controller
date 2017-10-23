/*=============================================================================
 * This document contains information proprietary to the CSULB student that 
   created the file - any reuse without adequate approval and documentation is 
   prohibited. 
 * Class:      CECS 360 - Integrated Circuit Design Software 
 * File Name:  vga_controller_top_tf.v
 * Project:    VGA Controller
 * Designer:   Michael Rios - Copyright © 2017. All rights reserved. 
 * Email:      riosmichael28@ymail.com
 * Rev. Date:  October 20, 2017
 *
 * Description: This module is a text fixture for the vga_controller module. 
                This module is a self-checking test bench, meaning that 
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

module vga_controller_top_tf;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire hsync;
	wire vsync;
	wire [11:0] rgb;



   reg flag = 1'b0; 
   // =======================================================
   // Generate the 25MHz pixel rate from the 100Mhz board clk  
   // =======================================================

   reg [1:0] pxl_clk; 
   wire tick;
   assign tick = pxl_clk == 2'b11; 
    
   always @ (posedge clk, posedge rst)
      
      if (rst)       pxl_clk <= 2'b0; 
      else if (tick) pxl_clk <= 2'b0;
      else           pxl_clk <= pxl_clk + 2'b1; 
      
   // ================================
   // Horizontal Sync 
   // Horizontal count 0 ... 799
   // Update at 25MHz
   // ================================
   
   reg [9:0] hcount;
   wire endh;
   assign endh = (hcount == 10'd799); 
   
   always @ (posedge clk, posedge rst) 
      if (rst) hcount <= 10'b0; 
      else if (tick) 
         if (endh)   hcount <= 10'b0; 
         else        hcount <= hcount + 10'b1; 
         
         assign pixel_x = hcount;
      
   // ================================
   // Vertical Sync 
   // Vertical count 0 ... 524
   // Update at 25MHz
   // ================================
   
   reg [9:0] vcount; 
   wire endv;
   assign endv = (vcount == 10'd524);
   
   always @ (posedge clk, posedge rst) 
      if (rst) vcount <= 10'b0; 
      else if (tick) 
         if (endh)
            if (endv)
               begin
                  vcount <= 10'b0; 
                  //check the flag register which will 
                  // be asserted if there is an error
                  if (flag == 1'b1) $display("Error"); 
                  else              $display("Success"); 
                  
                  // finish simulation after display has 
                  // been scanned once 
                  $finish;
               end
            else        vcount <= vcount + 10'b1; 
            
    
    assign pixel_y = vcount;


	// Instantiate the Unit Under Test (UUT)
	vga_controller_top uut (
		.clk(clk), 
		.rst(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb)
	);
   
   // generate 10ns clk
   always 
      #10 clk = ~clk; 
   
   always @ (posedge clk, posedge rst)
   begin 
          
          // Verify the placement of the wall
          if (pixel_x >= 32 && pixel_x <= 35 && !(rgb == 12'h00f))  
               flag = 1'b1;
          
          // Verify the placement of the ball    
          else if ((pixel_x >= 580) && (pixel_x <= 588) && (pixel_y >= 238) 
                   && (pixel_y <= 246) && !(rgb == 12'hf00))
               flag = 1'b1;
          
          // Verify the placement of the paddlea
          else if ((pixel_x >= 600) && (pixel_x <= 603) && (pixel_y >= 204)
                   && (pixel_y <= 276) && !(rgb == 12'h0f0))
               flag = 1'b1;
          
          // Verify that no pixel displays when display should be off
          else if (pixel_x > 640 && !(rgb == 12'h000)) 
               flag = 1'b1;
               
          // Verify that no pixel displays when display should be off
          else if (pixel_y > 480 && !(rgb == 12'h000)) 
               flag = 1'b1;
          
          // Display "Success" if every case is satisfied 
          else 
               flag = 1'b0;

   end
      
	initial begin
		// Initialize Inputs
      clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;

    end 

      
endmodule

