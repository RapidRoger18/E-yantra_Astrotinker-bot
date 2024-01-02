module pid_control (
    input clk,
    input [3:0]dutycyc_left,
    input [3:0]dutycyc_right,
    input [11:0]left_value,
    input [11:0]center_value,
    input [11:0]right_value,
    output reg [3:0] dutycyc_1,
    output reg [3:0] dutycyc_2
);

parameter Kp = 1;
parameter Kd = 1;
parameter Ki = 1;

reg read_left, read_center,read_right ;
reg [3:0]error;
reg [3:0]prev_error=0;
reg [3:0]proportional;
reg [3:0]derivative;
reg [3:0]integral=0;
reg [3:0] correction ;

always@(posedge clk) begin
    if (left_value<300) read_left<=0;
    else read_left<=1;

     if (center_value>1000) read_center<=1;
    else read_center<=0;

     if (right_value<300) read_right<=0;
    else read_right<=1;

    error <= ((3*read_right+1*read_center-3*read_left)-1)/(read_right+read_center+read_center); //weighted sum - 1/ sum
    proportional<= Kp * error;
    derivative <= Kd * (error-prev_error);
    integral <= integral + (Ki*error);

    correction<=proportional+derivative+integral;
    dutycyc_1<=dutycyc_left+correction;
    dutycyc_2<=dutycyc_right-correction;

    prev_error<=error;

end



endmodule