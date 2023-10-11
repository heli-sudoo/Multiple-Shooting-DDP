function [lf,qvf,Qf] = acrobot_fcost_quad_approx(in1)
%ACROBOT_FCOST_QUAD_APPROX
%    [LF,QVF,Qf] = ACROBOT_FCOST_QUAD_APPROX(IN1)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    10-Oct-2023 22:15:46

x1 = in1(1,:);
x2 = in1(2,:);
x3 = in1(3,:);
x4 = in1(4,:);
t2 = x2.*1.175125119022698e+3;
t3 = x4.*1.175125119022698e+3;
t4 = x2.*2.381083681988686e+3;
t5 = x3.*2.381083681988686e+3;
t6 = x3.*2.287321781813826e+3;
t7 = x1.*5.28360374681366e+3;
t8 = x3.*5.28360374681366e+3;
t9 = x3.*1.127229611172123e+3;
t10 = x4.*1.127229611172123e+3;
t11 = x1.*5.497053232250479e+3;
t12 = x2.*5.497053232250479e+3;
t13 = x4.*5.558592485902038e+2;
t14 = x2.*2.488427520364404e+3;
t15 = x1.*2.603290955320116e+3;
t16 = x4.*2.603290955320116e+3;
t17 = x1.*1.220680577288347e+4;
t18 = t3+t5+t11+t14;
t19 = t4+t6+t7+t10;
t20 = t2+t9+t13+t15;
t21 = t8+t12+t16+t17;
lf = (t18.*x2)./2.0+(t19.*x3)./2.0+(t21.*x1)./2.0+(t20.*x4)./2.0;
if nargout > 1
    qvf = [t21;t18;t19;t20];
end
if nargout > 2
    mt1 = [1.220680577288347e+4,5.497053232250479e+3,5.28360374681366e+3,2.603290955320116e+3,5.497053232250479e+3,2.488427520364404e+3];
    mt2 = [2.381083681988686e+3,1.175125119022698e+3,5.28360374681366e+3,2.381083681988686e+3,2.287321781813826e+3,1.127229611172123e+3];
    mt3 = [2.603290955320116e+3,1.175125119022698e+3,1.127229611172123e+3,5.558592485902038e+2];
    Qf = reshape([mt1,mt2,mt3],4,4);
end
