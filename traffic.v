// Title : A simple traffic light controller, controller an intersectio
// that runs NS and EW, with programmable green light and yellow light on timer.
// Inputs : clk, rst (but no sensor)
// Output : ns_green, ns_yellow, ns_red, ew_green, ew_yello, ew_red
// Author : Albert Chiang

module traffic (clk, rst_, ns_green, ns_yellow, ns_red, ew_green, ew_yellow, ew_red);

input clk;
input rst_;
output ns_green;
output ns_yellow;
output ns_red;
output ew_green;
output ew_yellow;
output ew_red;

reg ns_green;
reg ns_yellow;
reg ns_red;
reg ew_green;
reg ew_yellow;
reg ew_red;
reg flip_o;
reg cnt64_go;
reg flip_i;
reg cnt64_done;
reg cnt4_go;
reg cnt4_done;

typedef enum {RST = 5'b00001, NS_G_R = 5'b00010, NS_Y_R = 5'b00100, NS_R_Y = 5'b01000, NS_R_G = 5'b10000 } STATE;

STATE ps, ns; 

// reg [4:0] ps, ns; 
reg [5:0] cnt_64;
reg [1:0] cnt_4;

// 64 clk
always @(posedge clk or rst_ or cnt64_go) begin
   if (rst_ == 1'b0) begin
      cnt_64 <= 6'b000000;
      // flip_i <= 1'b0;
      cnt64_done <= 1'b0;
   end
   // else if (flip_o == 1'b1)
   else if (cnt64_go == 1'b1)
      cnt_64 <= cnt_64 + 6'b000001;
      if (cnt_64 == 6'b111111) 
         cnt64_done <= 1'b1;
         // flip_i <= 1'b1;
      else
         // flip_i <= 1'b0;
         cnt64_done <= 1'b0;
end

// 4 clk
always @(posedge clk or rst_ or cnt4_go) begin
   if (rst_ == 1'b0) begin
      cnt_4 <= 2'b00;
      cnt4_done <= 1'b0;
   end
   else if (cnt4_go == 1'b1)
      cnt_4 <= cnt_4 + 2'b01;
      if (cnt_4 == 2'b11) 
         cnt4_done <= 1'b1;
      else
         cnt4_done <= 1'b0;
end

// next state flop
always @(posedge clk or rst_) begin
   if (rst_ == 1'b0)
      ps <= RST;
   else
      ps <= ns;
end

// next state calc
// always @(ps or flip_i) begin
always @(ps or cnt64_done or cnt4_done) begin
   case (ps) 
      RST: begin
         ns <= NS_G_R;
         // flip_o <= 1'b0;
         cnt64_go <= 1'b0;
      end
      NS_G_R :  begin
         // flip_o <= 1'b1; // start 64 clk
         cnt64_go <= 1'b1; // start 64 clk
         cnt4_go <= 1'b0; // start 4 clk
         // if (flip_i == 1'b1) begin
         if (cnt64_done == 1'b1) begin
            ns <= NS_Y_R;
            // flip_o <= 1'b0; // reset 64 clk
         end
      end

      NS_Y_R: begin
         // flip_o <= 1'b0; // reset 64 clk
         cnt64_go <= 1'b0; // reset 64 clk
         cnt4_go <= 1'b1;
         if (cnt4_done == 1'b1) begin
            ns <= NS_R_G;
         end
      end
      NS_R_G :  begin
         cnt64_go <= 1'b1; // start 64 clk
         cnt4_go <= 1'b0; // reset 4 clk
         if (cnt64_done == 1'b1) begin
            ns <= NS_R_Y;
         end
      end
      NS_R_Y:  begin
         cnt64_go <= 1'b0; // reset 64 clk
         cnt4_go <= 1'b1; // start 4 clk
         if (cnt4_done == 1'b1) begin
            ns <= NS_G_R;
         end
      end
   endcase
end

// output, moore
always @(ps) begin
   case (ps) 
      // 5'b00001 :  begin// RST
      RST:  begin// RST
         ns_green <= 1'b0; 
         ns_yellow <= 1'b0; 
         ns_red <= 1'b1; 
         ew_green <= 1'b0; 
         ew_yellow <= 1'b0; 
         ew_red <= 1'b1; 

      end
      
      // 5'b00010 :  begin // NS_G, EW_R
      NS_G_R :  begin // NS_G, EW_R
         ns_green <= 1'b1; 
         ns_yellow <= 1'b0; 
         ns_red <= 1'b0; 
         ew_green <= 1'b0; 
         ew_yellow <= 1'b0; 
         ew_red <= 1'b1; 


      end
      // 5'b00100 :  begin // NS_Y, EW_R
      NS_Y_R :  begin // NS_Y, EW_R
         ns_green <= 1'b0; 
         ns_yellow <= 1'b1; 
         ns_red <= 1'b0; 
         ew_green <= 1'b0; 
         ew_yellow <= 1'b0; 
         ew_red <= 1'b1; 


      end
      // 5'b01000 :  begin // NS_R, EW_G
      NS_R_G :  begin // NS_R, EW_G
         ns_green <= 1'b0; 
         ns_yellow <= 1'b0; 
         ns_red <= 1'b1; 
         ew_green <= 1'b1; 
         ew_yellow <= 1'b0; 
         ew_red <= 1'b0; 


      end
      // 5'b10000 :  begin // NS_R, EW_Y
      NS_R_Y:  begin // NS_R, EW_Y
         ns_green <= 1'b0; 
         ns_yellow <= 1'b0; 
         ns_red <= 1'b1; 
         ew_green <= 1'b0; 
         ew_yellow <= 1'b1; 
         ew_red <= 1'b0; 


      end
   endcase
end


endmodule
