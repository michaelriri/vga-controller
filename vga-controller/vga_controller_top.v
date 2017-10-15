/*=============================================================================
 * This document contains information proprietary to the CSULB student that 
   created the file - any reuse without adequate approval and documentation is 
   prohibited. 
 * Class:      CECS 360 - Integrated Circuit Design Software 
 * File Name:  vga_controller_top.v
 * Project:    VGA Controller
 * Designer:   Michael Rios - Copyright © 2017. All rights reserved. 
 * Email:      riosmichael28@ymail.com
 * Rev. Date:  October 11, 2017
 *
 * Description: This is the VGA's top level module. This module is used for 
                the purpose of outputting the rgb signals based on the active
                switches on the Nexys 4 DDR board. This, combined with the 
                vga sync block, will output the desired color on the VGA 
                display. 
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

module vga_controller_top(clk, rst, sw, hsync, vsync, rgb);

   input    clk, rst;
   input    [11:0] sw; 
   output   [11:0] rgb; 
   output   hsync, vsync; 
   
   wire     video_on, rst_s;
   wire     [9:0] pixel_x, pixel_y; 
      
   aiso_rst    u0(.clk(clk), .reset(rst), .reset_s(rst_s));
   vga_sync    u1(.clk(clk), .rst(rst_s), .hsync(hsync),.vsync(vsync), 
                  .pixel_x(pixel_x), .pixel_y(pixel_y), 
                  .video_on(video_on));
                  
   graphic_generator u2(.clk(clk), .pixel_x(pixel_x), .pixel_y(pixel_y), 
                        .video_on(video_on), .rgb(rgb));               
   
   

endmodule
