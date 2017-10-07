/*=============================================================================
 * This document contains information proprietary to the CSULB student that 
   created the file - any reuse without adequate approval and documentation is 
   prohibited. 
 * Class:      CECS 360 - Integrated Circuit Design Software 
 * File Name:  vga_sync.v
 * Project:    VGA Controller
 * Designer:   Michael Rios - Copyright © 2017. All rights reserved. 
 * Email:      riosmichael28@ymail.com
 * Rev. Date:  October 1, 2017
 *
 * Description: This is the VGA's synchronization block. This module is in 
                charge of generating the following signals: 
                (1) hsync - specifies the required time to traverse a row
                (2) vsync - specifies the required time to traverse the 
                    entire screen. 
                (3) pixel_x - specifies the specific horizontal pixel currently 
                              being scanned. 
                (4) pixel_y - specifies the specific vertical pixel currently 
                              being scanned. 
                NOTE: The calcultions in this module are based on a 640 x 480 
                      VGA screen with a 25MHz refresh rate(known as VGA mode). 
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

module vga_sync(clk, rst, hsync, vsync, pixel_x, pixel_y, video_on);
   
   input    clk, reset; 
   output   hsync, vsync, pixel_x, pixel_y, video; 
   
   // =======================================================
   // Generate the 25MHz pixel rate from the 100Mhz board clk  
   // =======================================================

   reg [1:0] pxl_clk; 
   wire tick;
   assign tick = pixel_clk == 2'b11; 
    
   always @ (posedge clk, posedge rst)
      
      if (reset)     pxl_clk <= 2'b0; 
      else if (tick) pxl_clk <= 2'b0;
      else           pxl_clk <= pxl_clk + 2'b1; 
      
   // ================================
   // Horizontal Sync 
   // Horizontal count 0 ... 799
   // Update at 25MHz
   // ================================
   
   reg [9:0] hcount;
   wire endh;
   assign endh = hcount == 10'd799; 
   
   always @ (posedge clk, posedge rst) 
      if (rst) hcount <= 10'b0; 
      else if (tick) 
         if (endh)   hcount <= 10'b0; 
         else        hcount <= hcount + 10'b1; 
         
   assign hsync = ~(hcount >= 656 & hcount <= 751); 
      
      
   // ================================
   // Vertical Sync 
   // Vertical count 0 ... 524
   // Update at 25MHz
   // ================================
   
   reg [9:0] vcount; 
   wire endv;
   assign endv = hcount == 10'd524;
   
   always @ (posedge clk, posedge rst) 
      if (rst) vcount <= 10'b0; 
      else if (tick) 
         if (endv)   vcount <= 10'b0; 
         else        vcount <= vcount + 10'b1; 
         
   assign vsync = ~(vcount >= 490 & vcount <= 491);    
   
   assign pixel_x    =  hcount; 
   assign pixel_y    =  vcount; 
   assign video_on   =  (hcount < endh) && (vcount< endv);


endmodule
