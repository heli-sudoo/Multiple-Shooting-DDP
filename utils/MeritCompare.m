clear
dir_name = "data/Quadrotor/MeritTest";

data = load(dir_name + "/ConstSimple_1e2.mat");
CS_small.cost = [data.test_data.cost];
CS_small.defect = [data.test_data.defect];
% CS_small.dweight = [data.test_data.dweight];
CS_small.iters = 1:data.test_data.iter;

data = load(dir_name + "/ConstSimple_1e4.mat");
CS_large.cost = [data.test_data.cost];
CS_large.defect = [data.test_data.defect];
% CS_large.dweight = [data.test_data.dweight];
CS_large.iters = 1:data.test_data.iter;

data = load(dir_name + "/ConstExactCost_1e4.mat");
CE_large.cost = [data.test_data.cost];
CE_large.defect = [data.test_data.defect];
% CE_large.dweight = [data.test_data.dweight];
CE_large.iters = 1:data.test_data.iter;

data = load(dir_name + "/AdaptSimple.mat");
AS.cost = [data.test_data.cost];
AS.defect = [data.test_data.defect];
AS.dweight = [data.test_data.dweight];
AS.iters = 1:data.test_data.iter;

data = load(dir_name + "/AdaptExactCost.mat");
AE.cost = [data.test_data.cost];
AE.defect = [data.test_data.defect];
AE.dweight = [data.test_data.dweight];
AE.iters = 1:data.test_data.iter;

myred = [0.6350 0.0780 0.1840];
myyel = [0.9290 0.6940 0.1250];
myblu = [0 0.4470 0.7410];
mygrn = [0.4660 0.6740 0.1880];
myorg = [0.8500 0.3250 0.0980];
myprp = [0.4940 0.1840 0.5560];


figure;
% subplot(3,1,1)
% plot(CS_small.iter, CS_small.cost,"Color",myred);
hold on;
plot(CS_large.iters, CS_large.cost,"Color",mygrn);
plot(CE_large.iters, CE_large.cost,"Color",myorg);
plot(AS.iters, AS.cost(2:end),"Color",myblu);
plot(AE.iters, AE.cost(2:end),"Color",myprp);
title("Cost", 'FontSize',12);

figure;
% subplot(3,1,1)
% plot(CS_small.iter, CS_small.cost,"Color",myred);
hold on;
plot(CS_large.iters, CS_large.defect,"Color",mygrn);
plot(CE_large.iters, CE_large.defect,"Color",myorg);
plot(AS.iters, AS.defect(2:end),"Color",myblu);
plot(AE.iters, AE.defect(2:end),"Color",myprp);
set(gca, 'YScale', 'log')
title("Cost", 'FontSize',12);

figure;
bar(AS.dweight)
