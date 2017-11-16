/*=============================================================================
 * This document contains information proprietary to the CSULB student that 
   created the file - any reuse without adequate approval and documentation is 
   prohibited. 
 * Class:      CECS 360 - Integrated Circuit Design Software 
 * File Name:  graphic_generator.v
 * Project:    VGA Controller
 * Designer:   Michael Rios - Copyright © 2017. All rights reserved. 
 * Email:      riosmichael28@ymail.com
 * Rev. Date:  November 13, 2017
 *
 * Description: This module is in charge of displaying 3 objects on the screen: 
                the wall, the ball, and the paddle. The ball and paddle will be 
                animated objects. This animation is achieved by changing the 
                location of each object gradually in each scan. 
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

module graphic_generator(clk, rst, btn, pixel_x, pixel_y, video_on, rgb);

   input    clk, rst; 
   input    [1:0] btn; 
   input    [9:0] pixel_x, pixel_y; 
   input    video_on; 
   
   output   [11:0] rgb; 
   reg      [11:0] rgb; 
   
   wire     refr_tick; 
   
   // refr-tick: 1-clock tick asserted at st art of v-sync
   // i.e.. when the screen is refreshed (60 Hz)
   assign refr_tick = (pixel_y==481) && (pixel_x==0); 

   // ==========================
   // object output signals
   // ==========================
   
   wire wall_on, paddle_on, ball_on; 
   wire [11:0] wall_rgb, paddle_rgb, ball_rgb; 
   
   always @ (posedge clk, posedge rst) 
      if (rst) 
         begin   
            paddle_y_reg <= 0; 
            ball_x_reg   <= 0; 
            ball_y_reg   <= 0; 
            x_delta_reg  <= 10'h004; 
            y_delta_reg  <= 10'h004; 
         end
      else 
         begin 
            paddle_y_reg <= paddle_y_next; 
            ball_x_reg   <= ball_x_next; 
            ball_y_reg   <= ball_y_next; 
            x_delta_reg  <= x_delta_next; 
            y_delta_reg  <= y_delta_next; 
         end 
         
   // ===============
   // wall
   // ===============

   assign wall_on  = (pixel_x >= 32) && (pixel_x <= 35); 
   assign wall_rgb = 12'h00F;  // blue 
   
   // ===============
   // paddle
   // ===============
   
   wire [9:0] paddle_y_t, paddle_y_b; 
   // register to track top boundary (x position is fixed) 
   reg [9:0] paddle_y_reg, paddle_y_next; 

   assign paddle_y_t = paddle_y_reg; 
   assign paddle_y_b = paddle_y_t + 72 - 1; 
   
   assign paddle_on  = (pixel_x >= 600) && (pixel_x <= 603) && 
                       (pixel_y >= paddle_y_t) && (pixel_y <= paddle_y_b);  //bar top and bottom barriers
   assign paddle_rgb = 12'h0F0; // green
   
   // new paddle y-postion 
   always@ (*) 
   begin
      paddle_y_next = paddle_y_reg; 
      if (refr_tick)
         if (btn[1] & (paddle_y_b < (480 - 1 - 4))) //maxy -1- (bar moving velocity)
            paddle_y_next = paddle_y_reg + 4;  // move down 
         else if (btn[0] & (paddle_y_t > 4))
            paddle_y_next = paddle_y_reg - 4;  // move up 
   end 
   
   // ===============
   // ball 
   // ===============
   
   // ball left, right boundary 
   wire [9:0] ball_x_l, ball_x_r; 
   // ball tob, bottom boundary 
   wire [9:0] ball_y_t, ball_y_b;  
   // reg to track left , top position
   reg [9:0] ball_x_reg , ball_y_reg ;
   wire [9:0] ball_x_next , ball_y_next ; 
   //registers to track ball speed
   reg [9:0] x_delta_reg, x_delta_next; 
   reg [9:0] y_delta_reg, y_delta_next; 
   
   //boundary 
   assign ball_x_l = ball_x_reg; 
   assign ball_y_t = ball_y_reg; 
   assign ball_x_r = ball_x_l + 8 - 1; 
   assign ball_y_b = ball_y_t + 8 - 1;
   
   //pixel within ball 
   assign ball_on = (pixel_x >= ball_x_l) && (pixel_x <= ball_x_r) && 
                    (pixel_y >= ball_y_t) && (pixel_y <= ball_y_b); 
   assign ball_rgb = 12'hF00; //red 
  
  // new ball position 
   assign ball_x_next = (refr_tick) ? ball_x_reg + x_delta_reg : ball_x_reg; 
   assign ball_y_next = (refr_tick) ? ball_y_reg + y_delta_reg : ball_y_reg; 
   
   // new ball velocity 
   always @ (*) 
   begin 
      x_delta_next = x_delta_reg; 
      y_delta_next = y_delta_reg; 
      if (ball_y_t < 1) //reach top 
         y_delta_next = 2; 
      else if (ball_y_b > (480 - 1)) // reach bottom 
         y_delta_next = -2; 
      else if (ball_x_l <= 35) // reach wall 
         x_delta_next = 2; //bounce back 
      else if ((ball_x_r >= 600) && (ball_x_r <= 603) &&
               (ball_y_b >= paddle_y_t) && (ball_y_t <= paddle_y_b))
         // reach x of right paddle and hit, ball bounces back 
         x_delta_next = -2; 
   end 
      
   // ========================
   // rgb multiplexing circuit 
   // ========================
   always @ (*) 
      if (~video_on) 
         rgb = 3'b000; //blank 
      else if (wall_on) 
         rgb = wall_rgb; 
      else if (paddle_on) 
         rgb = paddle_rgb; 
      else if (ball_on) 
         rgb = ball_rgb; 
      else 
         rgb = 12'hFFF; // white background


endmodule
