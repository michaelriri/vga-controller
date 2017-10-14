/*=============================================================================
 * This document contains information proprietary to the CSULB student that 
   created the file - any reuse without adequate approval and documentation is 
   prohibited. 
 * Class:      CECS 360 - Integrated Circuit Design Software 
 * File Name:  vga_sync_tf.v
 * Project:    VGA Controller
 * Designer:   Michael Rios - Copyright © 2017. All rights reserved. 
 * Email:      riosmichael28@ymail.com
 * Rev. Date:  October 11, 2017
 *
 * Description: This is the text fixture for the vga_sync module. This module's 
                primary purpose is to test the signals generated in the vga_sync 
                module. The first actual module is simple and involves testing 
                the reset and then deasserting reset. The actual signals are 
                tested in the simulation. 
                (1) The first step was to make sure the counters were working 
                correctly with: 
                  - pixel_x counting from 0 to 799 
                  - pixel_y counting from 0 to 524 
                  
                (2) The hsync and vsync signals were analyzed to ensure: 
                  - hsync was active low when the horizontal count was between 
                  656 and 751. 
                  - vysnc was active low when the vertical count was between 
                  
                (3) The video_on signal was examined to ensure that it was only 
                     active when the vertical count was less than 480 and the 
                     horizontal count was less than 800
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

module vga_sync_tf;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire hsync;
	wire vsync;
	wire [9:0] pixel_x;
	wire [9:0] pixel_y;
	wire video_on;

	// Instantiate the Unit Under Test (UUT)
	vga_sync uut (
		.clk(clk), 
		.rst(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.pixel_x(pixel_x), 
		.pixel_y(pixel_y), 
		.video_on(video_on)
	);

   always 
      #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0; 
      rst = 1; 
     
		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;

	end
      
endmodule
      

