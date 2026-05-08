%% ENGS 60; Lab 2 - Solar Cells
% 
% 07/05/2026 Sergei Leonov
max_VI = {[0, 35.2], [0.1, 35], [2.005, 34], [2.62, 32], [3.03, 30], [4.28, 29], [5.03, 28], [5.563, 25], [5.616, 22], [5.723, 20], [5.819, 18], [5.905, 16], [5.964, 14], [6.050, 12], [6.100, 10], [6.15, 8], [6.200, 6], [6.252, 4], [6.283, 2], [6.300, 0], [6.411, -2], [6.450, -4.5], [6.49, -8], [6.511, -10], [6.569, -14], [6.592, -18], [6.620, -20]};
max_VI = vertcat(max_VI{:});
xmax = max_VI(:,1); ymax = max_VI(:,2);

half_VI = {[0, 17], [0.96, 14.5], [3.132, 14], [4.300, 12], [4.63, 10], [4.849, 8], [4.928, 7], [5.137, 5], [5.332, 2], [5.442, 0], [5.509, -1], [5.642, -3], [5.772, -5], [5.92, -8], [6.019, -10], [6.15, -12], [6.245, -15], [6.361, -17.4], [6.400, -20]};
half_VI = vertcat(half_VI{:});
xhalf = half_VI(:,1); yhalf = half_VI(:,2);

dark_VI = {[0, 0], [1, 0], [3.05, -1], [3.500, -2], [4.153, -5], [4.537, -7], [4.823, -10], [5.007, -12], [5.363, -16], [5.477, -18], [5.582, -20], [5.757, -25], [6.060, -30], [6.248, -32], [6.374, -35]};
dark_VI = vertcat(dark_VI{:});
xdark = dark_VI(:,1); ydark = dark_VI(:,2);

f1 = figure;
plot(xmax, ymax, LineWidth=2, Color="r");
hold on; grid on;
plot(xhalf, yhalf, LineWidth=2, Color="b");
plot(xdark, ydark, LineWidth=2);

xlabel("Voltage (V)");
ylabel("Current (mV)");
title("I-V Characteristic for Solar Cell for Varying Light Conditions")
legend("Max Brightness", "Half Brightness", "No Light")


%% Power Plot
P_max = xmax .* ymax;
P_half = xhalf .* yhalf;

f2 = figure;
plot(xmax, P_max, LineWidth=2, Color="r");
hold on; grid on;
plot(xhalf, P_half, LineWidth=2, Color="b");

xlabel("Voltage (V)");
ylabel("Power (mW)");
title("Power Plot for Solar Cell for Varying Light Conditions")
legend("Max Brightness", "Half Brightness", "Location", "southwest")
set(gca , 'FontSize', 20);

%% Fill Factor Calculation

% Maximum intensity
P_max_val_bright = 140.84; % mW experimental max power
V_power_max_bright = 5.03; % V voltage where max power occurs
I_short_bright = 35.2; % mA short circuit current
V_open_bright = 6.3; % V open circuit voltage

FF_bright = P_max_val_bright / (V_open_bright * I_short_bright) % fill factor for full brightness

% Half intensity
P_max_val_half = 51.6; % mW experimental max power
V_power_max_half = 4.3; % V voltage where max power occurs
I_short_half = 17.0; % mA short circuit current
V_open_half = 5.442; % V open circuit voltage

FF_half = P_max_val_half / (V_open_half * I_short_half) % fill factor for half5 brightness

figure(f1);
plot(V_power_max_bright, P_max_val_bright/V_power_max_bright, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r')
plot(V_power_max_half, P_max_val_half/V_power_max_half, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b')

figure(f2);
plot(V_power_max_bright, P_max_val_bright, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r')
plot(V_power_max_half, P_max_val_half, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b')
legend("Max Brightness", "Half Brightness", "Max Power Bright", "Max Power Half Bright","Location", "southwest")
set(gca , 'FontSize', 20);
saveas(gcf, 'power_linear.png');

figure(f1);

%% Resistance Calculation
R_bright = V_power_max_bright^2 / (P_max_val_bright * 1e-3) % Ohms (Power converted to W from mW)
R_half = V_power_max_half^2 / (P_max_val_half * 1e-3) % Ohms (Power converted to W from mW)

% plot resistive load using I = V/R
plot(xmax, xmax/R_bright * 1e3, "-r", LineWidth=2, LineStyle="--") % 1e3 converts to mA
plot(xhalf, xhalf/R_half * 1e3, "-b", LineWidth=2, LineStyle="--") % 1e3 converts to mA
fig1_lgd = {
    "Max Brightness", 
    "Half Brightness", 
    "Dark", 
    "Max Power Bright",
    "Max Power Half Bright",
    "Bright Resistive Load", 
    "Half Bright Resisitive Load"
};
legend(fig1_lgd, "Location", "southwest")
set(gca , 'FontSize', 20);
saveas(gcf, 'data_linear.png');

%% Log-Log Plot
f3 = figure;
loglog(xmax, ymax, LineWidth=2, Color="r")
hold on; grid on;
loglog(xhalf, yhalf, LineWidth=2, Color="b")
xlabel("Log Voltage (V)")
ylabel("Log Current (mA)")
title("Log-Log I-V Plot")
legend("Max Brightness", "Half Brightness", "Location", "southwest")
set(gca , 'FontSize', 20);
saveas(gcf, 'power_loglog.png');

%% Estimating Solar Cell Efficiency
Area = .125 * .063 % m^2
lux_bright = 16300; % lux
lux_half = 8020; % lux

bulb_eff = 100; % bulb efficiency
optical_power_bright = Area * lux_bright / bulb_eff
optical_power_half = Area * lux_half / bulb_eff

% compute power ratio (converting power to W from mW)
P_eff_bright = (P_max_val_bright * 1e-3) / optical_power_bright
P_eff_half = (P_max_val_half * 1e-3) / optical_power_half

%%
% Note that for different illumination conditions the power efficiency
% differs. We assumed standard coefficient for the light bulb

%% Compute Parellel Resitance via Linear Regression
f4 = figure;
plot(xmax, ymax, LineWidth=2, Color="r");
hold on; grid on;
plot(xhalf, yhalf, LineWidth=2, Color="b");
plot(xdark, ydark, LineWidth=2);

[fit, gof] = polyfit(xmax(1:8), ymax(1:8), 1)
R_parallel = 1 / (abs(fit(1)) * 1e-3) % Ohm, compute parallel resistance (converting to Amps)
plot(xmax, xmax * fit(1) + fit(2), LineStyle=":", LineWidth=2)
set(gca , 'FontSize', 20);
xline(V_open_bright/2, LineWidth=1.5, LineStyle=":")
xlabel("Voltage (V)");
ylabel("Current (mV)");
title("I-V Characteristic for Solar Cell for Varying Light Conditions")
legend("Max Brightness", "Half Brightness", "No Light", "Linear Regression Fit", "Voc/2", "Location", "southwest")
saveas(gcf, 'regression_fit.png');
%% 
