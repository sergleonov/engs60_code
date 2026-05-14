%% ENGS 60; Lab 3 - LED
% 
% 14/05/2026 Sergei Leonov

% load data
data = readtable("scope_2.csv");

t = data.Var1; % time
V_in = data.Var2 + abs(min(data.Var2)); % channel 1
V_diode = data.Var3; % channel 2
V_photo = data.Var4 * 10/9; % channel 3 (rescaled as was recorded at 900mV/div)

% plot results
f1 = figure;
yyaxis left;
plot(t, V_diode, LineWidth=2.2);
hold on; grid on;
plot(t, V_photo, LineWidth=2.2);
ylabel("Voltage [1V/div]");

yyaxis right;
plot(t, V_in, LineWidth=2.2);
ylim([0 1.2])
ylabel("Voltage [200mV/div]");

% add labels
legend("Diode voltage", "Phototransistor voltage", "Input Voltage")
title("Phototransistor and diode data plot");
xlabel("Time [ms]");
xlim([-.02 0.18])
set(gca , 'FontSize', 20);
saveas(gcf, 'data.png');
