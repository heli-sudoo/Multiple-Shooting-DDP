function [l,qv,Q,rv,R,S] = quadrotor_rcost_quad_approx(in1,in2)
%QUADROTOR_RCOST_QUAD_APPROX
%    [L,QV,Q,RV,R,S] = QUADROTOR_RCOST_QUAD_APPROX(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    19-Sep-2023 10:47:32

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
t2 = conj(u1);
t3 = conj(u2);
t4 = conj(u3);
t5 = conj(u4);
l = (t2.*u1)./2.0e+2+(t3.*u2)./2.0e+2+(t4.*u3)./2.0e+2+(t5.*u4)./2.0e+2+a_sym1.^2.*1.0e+1+a_sym2.^2.*1.0e+1+a_sym3.^2.*1.0e+1+p_sym1.^2.*1.0e+1+p_sym2.^2.*1.0e+1+p_sym3.^2.*1.0e+1+v_sym1.^2+v_sym2.^2+v_sym3.^2+w_sym1.^2.*1.0e+1+w_sym2.^2.*1.0e+1+w_sym3.^2.*1.0e+1;
if nargout > 1
    qv = [a_sym1.*2.0e+1;a_sym2.*2.0e+1;a_sym3.*2.0e+1;w_sym1.*2.0e+1;w_sym2.*2.0e+1;w_sym3.*2.0e+1;p_sym1.*2.0e+1;p_sym2.*2.0e+1;p_sym3.*2.0e+1;v_sym1.*2.0;v_sym2.*2.0;v_sym3.*2.0];
end
if nargout > 2
    Q = reshape([2.0e+1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0e+1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0e+1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0e+1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0e+1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0e+1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0e+1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0e+1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0e+1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,2.0],[12,12]);
end
if nargout > 3
    rv = [t2./2.0e+2+u1./2.0e+2;t3./2.0e+2+u2./2.0e+2;t4./2.0e+2+u3./2.0e+2;t5./2.0e+2+u4./2.0e+2];
end
if nargout > 4
    R = reshape([1.0./1.0e+2,0.0,0.0,0.0,0.0,1.0./1.0e+2,0.0,0.0,0.0,0.0,1.0./1.0e+2,0.0,0.0,0.0,0.0,1.0./1.0e+2],[4,4]);
end
if nargout > 5
    S = reshape([0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],[4,12]);
end
