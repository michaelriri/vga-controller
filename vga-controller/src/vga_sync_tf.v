`timescale 1ns / 1ps

module vga_sync_tf;

	// Inputs
	reg clk;
	reg rst;
	reg video_on;

	// Outputs
	wire hsync;
	wire vsync;
	wire pixel_x;
	wire pixel_y;

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

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		video_on = 0;

		// Wait 100 ns for global reset to finish
		#100;
       
		// Add stimulus here

	end
      
endmodule

