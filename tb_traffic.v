// File : tb_traffic.v 
// Title : A simple traffic light controller testbench for
// module traffic.
//
// Author : Albert Chiang

module tb_traffic();

reg clk;
reg rst_;

wire ns_green;
wire ns_yellow;
wire ns_red;
wire ew_green;
wire ew_yellow;
wire ew_red;


traffic traffic_0 (
   .clk(clk), 
   .rst_(rst_), 
   .ns_green(ns_green), 
   .ns_yellow(ns_yellow), 
   .ns_red(ns_red), 
   .ew_green(ew_green), 
   .ew_yellow(ew_yellow), 
   .ew_red(ew_red)
);


initial
   clk = 1'b0;

always
   #10 clk = ~clk;


initial begin
   $vcdpluson();
   $monitor("time=%d ns_green=%b ns_yellow=%b ns_red=%b w_green=%b ew_yellow=%b ew_red=%b ", $time(), ns_green, ns_yellow, ns_red, ew_g
reen, ew_yellow, ew_red);
   rst_ = 1'b0;
   #20;
   rst_= 1'b1;
   #5000;
   $finish();
end


endmodule
