clear
iiwa_dir = "data/IIWA/ShootingNodeTest/Revision";
qr_dir = "data/Quadrotor/ShootingNodeTest/Revision";


iiwa_data_no_weight = load(iiwa_dir + "/MSiLQR-zero-weight-400.mat");
iiwa_data_weight = load(iiwa_dir + "/MSiLQR-weight-400.mat");
qr_data_no_weight = load(qr_dir + "/MSiLQR-zero-weight-400.mat");
qr_data_weight = load(qr_dir + "/MSiLQR-weight-400.mat");

iiwa_nw.cost = [iiwa_data_no_weight.test_data.cost];
iiwa_nw.iter = [iiwa_data_no_weight.test_data.iter];
iiwa_ww.cost = [iiwa_data_weight.test_data.cost];
iiwa_ww.iter = [iiwa_data_weight.test_data.iter];
iiwa_M = [iiwa_data_weight.test_data.M];

qr_nw.cost = [qr_data_no_weight.test_data.cost];
qr_nw.iter = [qr_data_no_weight.test_data.iter];
qr_ww.cost = [qr_data_weight.test_data.cost];
qr_ww.iter = [qr_data_weight.test_data.iter];
qr_M = [qr_data_weight.test_data.M];

myred = [0.8500 0.3250 0.0980];
myblu = [0 0.4470 0.7410];
myyel = [0.9290 0.6940 0.1250];
mygrn = [0.4660 0.6740 0.1880];

figure;
subplot(2,2,1)
plot(iiwa_M, iiwa_nw.cost, 'Color',myred,'LineWidth',3.0,'Marker','o');
hold on;
grid on;
plot(iiwa_M, iiwa_ww.cost, 'Color',myblu,'LineWidth',3.0,'LineStyle','-.','Marker','square');
ylabel({'Cost', 'at convergence'});
set(gca, 'Fontsize', 14);
xlim([0, 20]);
legend("MSiLQR", "MSiLQR-w-Penalty");
l.Orientation = "horizontal";
l.FontSize = 12;

subplot(2,2,3)
plot(iiwa_M, iiwa_nw.iter, 'Color',myred,'LineWidth',3.0,'Marker','o');
hold on;
grid on;
plot(iiwa_M, iiwa_ww.iter, 'Color',myblu,'LineWidth',3.0,'LineStyle','-.','Marker','square');
xlabel("Number of shooting nodes")
ylabel({'Iterations', 'at convergence'});
set(gca, 'Fontsize', 14);
xlim([0, 20]);
l.Orientation = "horizontal";
l.FontSize = 12;

subplot(2,2,2)
plot(qr_M, qr_nw.cost, 'Color',myred,'LineWidth',3.0,'Marker','o');
hold on;
grid on;
plot(qr_M, qr_ww.cost, 'Color',myblu,'LineWidth',3.0,'LineStyle','-.','Marker','square');
ylim([2878, 2880]);
set(gca, 'Fontsize', 14);
xlim([0, 20]);
legend("MSiLQR", "MSiLQR-w-Penalty");
l.Orientation = "horizontal";
l.FontSize = 12;

subplot(2,2,4)
plot(qr_M, qr_nw.iter, 'Color',myred,'LineWidth',3.0,'Marker','o');
hold on;
grid on;
plot(qr_M, qr_ww.iter, 'Color',myblu,'LineWidth',3.0,'LineStyle','-.','Marker','square');
xlabel("Number of shooting nodes")
set(gca, 'Fontsize', 14);
xlim([0, 20]);
l.Orientation = "horizontal";
l.FontSize = 12;




