/*=============================================================================
 * This document contains information proprietary to the CSULB student that 
   created the file - any reuse without adequate approval and documentation is 
   prohibited. 
 * Class:      CECS 360 - Integrated Circuit Design Software 
 * File Name:  graphic_generator.v
 * Project:    VGA Controller
 * Designer:   Michael Rios - Copyright © 2017. All rights reserved. 
 * Email:      riosmichael28@ymail.com
 * Rev. Date:  October 14, 2017
 *
 * Description: 
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

module graphic_generator(clk, rst, pixel_x, pixel_y, video_on, rgb);

   input    clk, rst, video_on; 
   input    [9:0] pixel_x, pixel_y; 
   output   [11:0]rgb; 
   
   wire     wall_on, ball_on, bar_on; 
   
   // ========================
   //          Wall 
   // ========================
   assign   wall_on = (pixel_x >= 32) && (pixel_x <= 35);  
   assign   wall_rgb = 12'h00F; // blue 
   
   // ========================
   //          Wall 
   // ========================
   assign   wall_on = (pixel_x >= 32) && (pixel_x <= 35);  
   assign   wall_rgb = 12'h00F; // blue 
   

endmodule
