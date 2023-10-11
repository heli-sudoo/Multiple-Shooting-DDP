function f = quadrotor_dynamics(in1,in2)
%QUADROTOR_DYNAMICS
%    F = QUADROTOR_DYNAMICS(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    19-Sep-2023 10:47:30

a_sym1 = in1(1,:);
a_sym2 = in1(2,:);
a_sym3 = in1(3,:);
p_sym1 = in1(7,:);
p_sym2 = in1(8,:);
p_sym3 = in1(9,:);
u1 = in2(1,:);
u2 = in2(2,:);
u3 = in2(3,:);
u4 = in2(4,:);
v_sym1 = in1(10,:);
v_sym2 = in1(11,:);
v_sym3 = in1(12,:);
w_sym1 = in1(4,:);
w_sym2 = in1(5,:);
w_sym3 = in1(6,:);
t2 = cos(a_sym1);
t3 = cos(a_sym2);
t4 = cos(a_sym3);
t5 = sin(a_sym1);
t6 = sin(a_sym2);
t7 = sin(a_sym3);
t9 = (w_sym1.*w_sym3)./2.0;
t10 = u1./8.0;
t11 = u3./8.0;
t12 = u1.*(7.0./3.0e+1);
t13 = u2.*(7.0./3.0e+1);
t14 = u3.*(7.0./3.0e+1);
t15 = u4.*(7.0./3.0e+1);
t19 = u2./4.0e+2;
t20 = u4./4.0e+2;
t21 = (w_sym2.*w_sym3)./1.0e+2;
t8 = 1.0./t3;
t16 = -t10;
t17 = -t13;
t18 = -t15;
t22 = -t20;
t23 = -t21;
t24 = t9+t11+t16;
t25 = t12+t14+t17+t18;
mt1 = [a_sym1+t19+t22+t23+(t2.*t6.*t8.*t25)./5.0e+1+(t5.*t6.*t8.*t24)./5.0e+1;a_sym2+(t2.*t24)./5.0e+1-(t5.*t25)./5.0e+1;a_sym3+(t2.*t8.*t25)./5.0e+1+(t5.*t8.*t24)./5.0e+1;t19+t22+t23+w_sym1;u1.*(-1.0./4.0e+2)+u3./4.0e+2+w_sym2+(w_sym1.*w_sym3)./1.0e+2;u1.*4.666666666666667e-3-u2.*4.666666666666667e-3+u3.*4.666666666666667e-3-u4.*4.666666666666667e-3+w_sym3;p_sym1-(v_sym2.*(t2.*t7-t4.*t5.*t6))./5.0e+1+(v_sym3.*(t5.*t7+t2.*t4.*t6))./5.0e+1+(t3.*t4.*v_sym1)./5.0e+1];
mt2 = [p_sym2+(v_sym2.*(t2.*t4+t5.*t6.*t7))./5.0e+1-(v_sym3.*(t4.*t5-t2.*t6.*t7))./5.0e+1+(t3.*t7.*v_sym1)./5.0e+1;p_sym3-(t6.*v_sym1)./5.0e+1+(t2.*t3.*v_sym3)./5.0e+1+(t3.*t5.*v_sym2)./5.0e+1;t6.*(4.9e+1./2.5e+2)+v_sym1;v_sym2-t3.*t5.*(4.9e+1./2.5e+2);u1./1.5e+2+u2./1.5e+2+u3./1.5e+2+u4./1.5e+2+v_sym3-t2.*t3.*(4.9e+1./2.5e+2)];
f = [mt1;mt2];
