function [lf,qvf,Qf] = quadrotor_fcost_quad_approx(in1)
%QUADROTOR_FCOST_QUAD_APPROX
%    [LF,QVF,Qf] = QUADROTOR_FCOST_QUAD_APPROX(IN1)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    19-Sep-2023 10:47:32

a_sym1 = in1(1,:);
a_sym2 = in1(2,:);
a_sym3 = in1(3,:);
p_sym1 = in1(7,:);
p_sym2 = in1(8,:);
p_sym3 = in1(9,:);
v_sym1 = in1(10,:);
v_sym2 = in1(11,:);
v_sym3 = in1(12,:);
w_sym1 = in1(4,:);
w_sym2 = in1(5,:);
w_sym3 = in1(6,:);
lf = a_sym1.^2.*5.0e+5+a_sym2.^2.*5.0e+5+a_sym3.^2.*5.0e+5+p_sym1.^2.*5.0e+5+p_sym2.^2.*5.0e+5+p_sym3.^2.*5.0e+5+v_sym1.^2.*5.0e+3+v_sym2.^2.*5.0e+3+v_sym3.^2.*5.0e+3+w_sym1.^2.*5.0e+3+w_sym2.^2.*5.0e+3+w_sym3.^2.*5.0e+3;
if nargout > 1
    qvf = [a_sym1.*1.0e+6;a_sym2.*1.0e+6;a_sym3.*1.0e+6;w_sym1.*1.0e+4;w_sym2.*1.0e+4;w_sym3.*1.0e+4;p_sym1.*1.0e+6;p_sym2.*1.0e+6;p_sym3.*1.0e+6;v_sym1.*1.0e+4;v_sym2.*1.0e+4;v_sym3.*1.0e+4];
end
if nargout > 2
    mt1 = [1.0e+6,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+6,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+6,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+4,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+4,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+4,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+6,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+6,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+6,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+4,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e+4,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
    mt2 = [1.0e+4];
    Qf = reshape([mt1,mt2],12,12);
end
