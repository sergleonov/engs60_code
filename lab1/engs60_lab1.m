%% ENGS 60; Lab 1 - Diodes
% 
% 28/04/2026 Sergei Leonov

close all
clear
clc

% parameters
q = 1.6e-19; % C
k = 1.38e-23; % Boltzmann const
T = 300; % K

% define model
model = fittype ( 'I0 * (exp(q * V / (n*k*T)) - 1)', 'independent' , 'V', 'coefficients' , {'I0', 'n'}, 'problem', {'q' , 'T' , 'k'}) ;
params = {q, T, k};
start = [1e-6 0.5];

% laod data 
data = readtable("1k 1.2V sweep.csv");
data2 = readtable("0.66 low res.csv");
data3 = readtable("0.66 sweep 100mV.csv");

% delete NaN values
data = rmmissing(data);
data2 = rmmissing(data2);
data3 = rmmissing(data3);

% time vectors
t = data.Var1;
t2 = data2.Var1;
t3 = data3.Var1;

% import data
ch11 = data.Var2;
ch21 = data.Var3;

ch12 = data2.Var2;
ch22 = data2.Var3;

ch13 = data3.Var2;
ch23 = data3.Var3;

% time plots
figure;
plot(t, ch11, LineWidth=1.6);
hold on; grid on;
plot(t, ch21, LineWidth=1.6);
plot(t2, ch12, LineWidth=1.6);
plot(t2, ch22, LineWidth=1.6);
plot(t3, ch13, LineWidth=1.6);
plot(t3, ch23, LineWidth=1.6);
xlabel("Time")
ylabel("Voltage")

% delete repetitive data
s1 = find(ch11 >= max(ch11), 1, 'first');
ch11 = ch11(1:s1);
ch21 = ch21(1:s1);

s2 = find(ch12 >= max(ch12), 1, 'first');
ch12 = ch12(1:s2);
ch22 = ch22(1:s2);

s3 = find(ch13 >= max(ch13), 1, 'first');
ch13 = ch13(1:s3);
ch23 = ch23(1:s3);
e3 = find(ch13 >= 0.489, 1, 'first');
ch13 = ch13(1:e3);
ch23 = ch23(1:e3);

ch21 = ch21./1e3; % convert to current with 1kOhm resistor
ch22 = ch22./1e4; % convert to current with 10kOhm resistor
ch23 = ch23./1e4; % convert to current with 10kOhm resistor

% compute coeffs for the fit
start_idx = find(ch12 >= 0.4, 1, 'first');
fit_v = ch12(start_idx:end);
fit_i = ch22(start_idx:end);
[fit, gof] = polyfit(fit_v, log(fit_i), 1)

slope = fit(1)     % this is q / (n*k*T)
intercept = fit(2) % this is ln(I0)

% compute model 
fit_v = linspace(min(ch11), max(ch11), 1000);
ln_y = slope * fit_v + intercept;
y = exp(ln_y); % convert to linear scale to get exponential

% compute initial current and ideality factor
I0 = exp(intercept)
n = 1/slope * (q/(k*T)) 

% IV linear Part 1
figure;
plot(ch11, ch21, LineWidth=3);
hold on; grid on;
plot(ch12, ch22, LineWidth=3);
plot(ch13, ch23, LineWidth=3);
xlabel("Voltage (V)")
ylabel("Current (A)")
title("Signal Diode, Forward Voltage (linear scale)")
set(gca , 'FontSize', 20);
legend("1 V/mA", "10 V/mA", "10 V/mA, Ch2: 100 mV/div", 'Location', 'northwest')
set(gca , 'FontSize', 20);
saveas(gcf, 'linear_IV_part1.png');

% IV log Part 1
figure;
semilogy(ch11, ch21, LineWidth=2);
hold on; grid on;
semilogy(ch12, ch22, LineWidth=2);
semilogy(ch13, ch23, LineWidth=2);
semilogy(fit_v, y, LineWidth=2.4, LineStyle="--");
xlabel("Voltage (V)")
ylabel("Current (A)")
title("Signal Diode, Forward Voltage (log scale)")
legend("1 V/mA", "10 V/mA", "10 V/mA, Ch2: 100 mV/div", "Fit (n=1.88, I_0 = 3.10e-9)", 'Location', 'southeast')
set(gca , 'FontSize', 20);
saveas(gcf, 'log_IV_part1.png');

%% Zener Diode
figure;
Z_data = readtable("zener part 1.csv");
tZ = Z_data.Var1;
Zch1 = Z_data.Var2; 
Zch2 = Z_data.Var3;
Zch2 = Zch2./1e3; % convert to current with 1kOhm resistor

plot(Zch1, Zch2, LineWidth=3)
hold on; grid on;
xlabel("Voltage (V)")
ylabel("Current (A)")
title("Zener Diode, Reverse Characteristic")
set(gca , 'FontSize', 20);
saveas(gcf, 'zener.png');

%% Signal Reverse

% import data
data_rev = readtable("backward breakdown last part.csv");

ts = data_rev.Var1;
ch1_rev = data_rev.Var2;
ch2_rev = data_rev.Var3;

ch2_rev = ch2_rev./10e6; % convert to current with 10 MOhm resisto

% delete repeated data
s_rev = find(ts >= -0.05023, 1, 'first');
e_rev = find(ts >= 0.0306, 1, 'first');
ch1_rev = ch1_rev(s_rev:e_rev);
ch2_rev = ch2_rev(s_rev:e_rev);
ts = ts(s_rev:e_rev);

% plot data
figure;
plot(ch1_rev, ch2_rev, LineWidth=3)
grid on;
title("Signal Diode, Reverse Voltage (Linear Scale)")
xlabel("Voltage (V)")
ylabel("Current (A)")
set(gca , 'FontSize', 20);
saveas(gcf, 'sig_rev.png');

% compute I = V^a fit 
[fit2, gof2] = polyfit(log(ch1_rev), log(ch2_rev), 1)

a = real(fit2(1))
I0_rev = real(exp(fit2(2)))

% voltage vector for plot
a_fit_i = I0_rev*ch1_rev.^a;

figure;
semilogy(ch1_rev, ch2_rev, LineWidth=3)
hold on; grid on;
semilogy(ch1_rev, a_fit_i, LineWidth=2.5);
title("Signal Diode, Reverse Voltage (Semilog Scale)")
xlabel("Voltage (V)")
ylabel("Current (A)")
legend("Data", "Fit I = (2.72e-9)V^{0.14}", 'Location', 'southeast')
set(gca , 'FontSize', 20);
saveas(gcf, 'sig_rev_log.png');
