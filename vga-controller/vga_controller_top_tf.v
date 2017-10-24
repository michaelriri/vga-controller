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
                This module is a self-checking test bench, meaning that the 
                design will anticipate what the outputs should be and inform 
                the user of any discrepancies. This module sets off a flag 
                when the rgb value at a given point is not its expected value
                and if the flag is set, then an error message will print to the
                console. 
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

   reg flag = 1'b0; // flag will be used to determine success

	// Instantiate the Unit Under Test (UUT)
	vga_controller_top uut (
		.clk(clk), 
		.rst(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb)
	);
      
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
   
   reg [9:0] pixel_x;
   wire endh;
   assign endh = (pixel_x == 10'd799); 
   
   always @ (posedge clk, posedge rst) 
      if (rst) pixel_x <= 10'b0; 
      else if (tick) 
         if (endh)   pixel_x <= 10'b0; 
         else        pixel_x <= pixel_x + 10'b1; 
               
      
   // ================================
   // Vertical Sync 
   // Vertical count 0 ... 524
   // Update at 25MHz
   // ================================
   
   reg [9:0] pixel_y; 
   wire endv;
   assign endv = (pixel_y == 10'd524);
   
   always @ (posedge clk, posedge rst) 
      if (rst) pixel_y <= 10'b0; 
      else if (tick) 
         if (endh)
            if (endv)   
            // After one scan, finish the simulation and 
            // display the results. 
               begin 
                  if (flag == 1'b1) $display("Error"); 
                  else              $display("Success");
                  $finish; 
               end 
            else        pixel_y <= pixel_y + 10'b1; 

    
   // Generate 10ns clk
   always 
      #5 clk = ~clk; 


   assign video_on   =  (pixel_x < 640) && (pixel_y < 480) ;

   // ================================
   // Verify the placement of the 
   // fixed objects by checking the 
   // RGB values at a the specified 
   // locations...
   // ================================
   always @ (posedge clk, posedge rst)
   begin 
      if(tick) 
         begin 
             // Verify that rgb = 000 when display is off
             if (~(video_on) && !(rgb==12'h000))
             begin 
               $display("pixel_x = %d  pixel_y = %d   rgb = %h", 
                         pixel_x,      pixel_y,       rgb); 
               flag = 1'b1;
             end
             
             // Verify the placement of the wall
             else if ((video_on) && (pixel_x >= 32) && (pixel_x <= 35) && !(rgb == 12'h00f))
               begin 
                  $display("pixel_x = %d  pixel_y = %d   rgb = %h NOT 00f", 
                            pixel_x,      pixel_y,       rgb); 
                  flag = 1'b1;
               end
             
             // Verify the placement of the ball    
             else if ((video_on) && (pixel_x >= 580) && (pixel_x <= 588) && (pixel_y >= 238) 
                      && (pixel_y <= 246) && !(rgb == 12'hf00))
               begin 
                  $display("pixel_x = %d  pixel_y = %d   rgb = %h", 
                            pixel_x,      pixel_y,       rgb); 
                  flag = 1'b1;
               end
             
             // Verify the placement of the paddle
             else if ((video_on) && (pixel_x >= 600) && (pixel_x <= 603) && (pixel_y >= 204)
                      && (pixel_y <= 276) && !(rgb == 12'h0f0))
               begin 
                  $display("pixel_x = %d  pixel_y = %d   rgb = %h", 
                            pixel_x,      pixel_y,       rgb); 
                  flag = 1'b1;
               end
          end
          // Display "Success" if every case is satisfied 
 
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
