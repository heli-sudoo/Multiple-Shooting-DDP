function f = acrobot_dynamics(in1,u)
%ACROBOT_DYNAMICS
%    F = ACROBOT_DYNAMICS(IN1,U)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    10-Oct-2023 22:15:46

x1 = in1(1,:);
x2 = in1(2,:);
x3 = in1(3,:);
x4 = in1(4,:);
t2 = cos(x1);
t3 = cos(x2);
t4 = sin(x1);
t5 = sin(x2);
t6 = x3.^2;
t7 = x4.^2;
t11 = u.*2.66e+4;
t13 = u.*1.663e+5;
t8 = t3.^2;
t9 = t5.^2;
t10 = t5.^3;
t12 = -t11;
t14 = t4.*1.30473e+5;
t15 = t3.*u.*2.0e+4;
t16 = -t13;
t17 = t5.*x3.*x4.*5.32e+4;
t18 = t4.*6.52365e+5;
t21 = t3.*u.*2.0e+5;
t22 = t5.*t6.*2.66e+4;
t23 = t5.*t7.*2.66e+4;
t24 = t3.*t4.*1.63827e+5;
t25 = t2.*t5.*3.26673e+5;
t26 = t5.*x3.*x4.*2.66e+5;
t31 = t5.*t7.*1.33e+5;
t32 = t5.*t6.*1.663e+5;
t35 = t2.*t3.*t5.*1.962e+5;
t37 = t3.*t5.*x3.*x4.*2.0e+5;
t41 = t3.*t5.*t6.*2.0e+4;
t43 = t2.*t3.*t5.*9.81e+5;
t47 = t3.*t5.*t7.*1.0e+5;
t48 = t3.*t5.*t6.*2.0e+5;
t19 = t8.*3.3e+4;
t20 = -t15;
t27 = t9.*1.33e+5;
t28 = -t21;
t29 = t8.*u.*1.0e+5;
t30 = t9.*u.*1.0e+5;
t33 = -t25;
t34 = t4.*t8.*6.4746e+4;
t39 = t4.*t8.*3.2373e+5;
t40 = t4.*t9.*2.60946e+5;
t42 = -t35;
t44 = t6.*t10.*1.0e+5;
t45 = t2.*t10.*9.81e+5;
t46 = t4.*t9.*1.30473e+6;
t49 = -t43;
t51 = t5.*t6.*t8.*1.0e+5;
t52 = t2.*t5.*t8.*9.81e+5;
t36 = -t29;
t38 = -t30;
t50 = -t45;
t53 = -t52;
t54 = t19+t27+4.4289e+4;
t56 = t12+t14+t17+t20+t22+t23+t34+t40+t41+t42;
t55 = 1.0./t54;
t57 = t16+t18+t24+t26+t28+t31+t32+t33+t36+t37+t38+t39+t44+t46+t47+t48+t49+t50+t51+t53;
f = [x1+x3./1.0e+2+(t55.*t56)./2.0e+3;x2+x4./1.0e+2-(t55.*t57)./1.0e+4;x3+(t55.*t56)./2.0e+1;x4-(t55.*t57)./1.0e+2];
