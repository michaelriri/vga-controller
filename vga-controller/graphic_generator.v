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

module graphic_generator(clk, pixel_x, pixel_y, video_on, rgb);

   input    clk, video_on; 
   input    [9:0] pixel_x, pixel_y; 
   output   [11:0]rgb; 
   
   wire     wall_on, ball_on, paddle_on; 
   wire     [11:0] wall_rgb, ball_rgb, paddle_rgb;
   
   // ========================
   //          Wall 
   // ========================
   assign   wall_on = (pixel_x >= 32) && (pixel_x <= 35);  
   assign   wall_rgb = 12'h00F; // blue 
   
   // ========================
   //          Ball  
   // ========================
   assign   ball_on = (pixel_x >= 580) && (pixel_x <= 588) && 
                      (pixel_y >= 238) && (pixel_y <= 246);  
   assign   ball_rgb = 12'hF00; // red 
   
   // ========================
   //          Paddle  
   // ========================
   assign   paddle_on = (pixel_x >= 600) && (pixel_x <= 603) && 
                        (pixel_y >= 204) && (pixel_y <= 276);  
   assign   paddle_rgb = 12'h0F0; // green
   
   always @ (*) 
      if (~video_on) 
         rgb = 12'h000; // blank
         
      else if (wall_on) 
         rgb = wall_rgb; 
         
      else if (ball_on) 
         rgb = ball_rgb; 
         
      else if (paddle_on) 
         rgb = paddle_rgb; 
         
      else 
         rgb = 12'hFFF; //white
   
   

endmodule
