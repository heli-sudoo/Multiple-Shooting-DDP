function la = acrobot_rcost_augment(in1,in2)
%ACROBOT_RCOST_AUGMENT
%    LA = ACROBOT_RCOST_AUGMENT(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    08-Dec-2022 00:43:55

a1 = in2(2,:);
a2 = in2(3,:);
a3 = in2(4,:);
a4 = in2(5,:);
u = in2(1,:);
la = a1.^2.*1.0e+1+a2.^2.*1.0e+1+a3.^2.*1.0e+1+a4.^2.*1.0e+1+u.^2./4.0e+1;