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

   // used to access the pixel_x and pixel_y signals 
   // from the vga_sync block...
   wire [9:0] pixel_x, pixel_y;
   assign  pixel_x  = uut.u1.pixel_x; 
   assign  pixel_y  = uut.u1.pixel_y; 

	// Instantiate the Unit Under Test (UUT)
	vga_controller_top uut (
		.clk(clk), 
		.rst(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb)
	);
   
   always 
      #10 clk = ~clk; 
   
   always @ (posedge clk)
   begin 
          
          // Verify the placement of the wall
          if (pixel_x >= 32 && pixel_x <= 35 && !(rgb == 12'h00f))  
               $display ("Pixel X = %d    Pixel Y = %d   rgb = %h    FAILURE", pixel_x, pixel_y, rgb);
          
          // Verify the placement of the ball    
          else if ((pixel_x >= 580) && (pixel_x <= 588) && (pixel_y >= 238) && (pixel_y <= 246) && 
                   !(rgb == 12'hf00))
               $display ("Pixel X = %d    Pixel Y = %d   rgb = %h    FAILURE", pixel_x, pixel_y, rgb);
          
          // Verify the placement of the paddlea
          else if ((pixel_x >= 600) && (pixel_x <= 603) && (pixel_y >= 204) && (pixel_y <= 276) && !(rgb == 12'h0f0))
               $display ("Pixel X = %d    Pixel Y = %d   rgb = %h    FAILURE", pixel_x, pixel_y, rgb);
          
          // Verify that no pixel displays when display should be off
          else if (pixel_x > 640 && !(rgb == 12'h000)) 
               $display ("Pixel X = %d    Pixel Y = %d   rgb = %h    FAILURE", pixel_x, pixel_y, rgb);
               
          // Verify that no pixel displays when display should be off
          else if (pixel_y > 480 && !(rgb == 12'h000)) 
               $display ("Pixel X = %d    Pixel Y = %d   rgb = %h    FAILURE", pixel_x, pixel_y, rgb); 
          
          //Display "Success" if every case is satisfied 
          else 
               $display ("SUCCESS");

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

