%%Assignment 1 of SIPE(Tu Delft, Wb2301)

clear all;
close all;
sim('LinearWhiteNoise'); % Run the model
whos;

% TD = Time Domain; FD = Frequency Domain
% # = number of

T = 5;           % The sampling length in TD
fs = 100;        % Sampling Frequency
dt = 1 / fs;     % Step of sampling in TD
N = T / dt;      % # samples

% Datum generated from Simulink
t = u.Time(1:N);
u = u.Data(1:N);
y = y.Data(1:N);

% Figure1: Raw Input u
% Figure2:
figure
subplot(211); plot(t,u);xlabel(' t [s]');ylabel('u [-]');title('input');
subplot(212); plot(t,y);xlabel(' t [s]');ylabel('y [-]');title('output');

%% Task1.1.a~c Calculate the Cross-correlation Function
% Note that the sequence in subscript & 'xcov' are inversed !
[Cuu, lags] = xcov(u, u, 'biased');
Cuy         = xcov(y, u, 'biased');
Cyu         = xcov(u, y, 'biased');
Cyy         = xcov(y, y, 'biased');
tau         = lags * dt;        % Time lag


% Plot 4 functions above

% Summary
% - The auto-covariance function of the input signal
% is non-zero only at tau=0;
% - Cuy & Cyu are in mirror-symmetry relation;
% - Cuy is(approximately) zero when tau<0 cuz causality;
% 

figure
subplot(221);
plot(tau, Cuu); xlabel('\tau [s]'); ylabel('C_{uu}');
subplot(222);
plot(tau, Cuy); xlabel('\tau [s]'); ylabel('C_{uy}');
subplot(223);
plot(tau, Cyu); xlabel('\tau [s]'); ylabel('C_{yu}');
subplot(224);
plot(tau, Cyy); xlabel('\tau [s]'); ylabel('C_{yy}');


% Highlight the proportion with the maxlag of 2 secs.
[Cuu_2, lag_2] = xcov(u, u, 2 / dt, 'biased');
tau_2          = lag_2 * dt;
figure
plot(tau, Cuu); hold on;
plot(tau_2, Cuu_2, 'r');
title('Maxlag Demonstration');
xlabel('\tau [s]'); ylabel('C_{uu}'); legend({'Cuu','Cuu_2'});

%% Task1.1.d Difference between biased & unbiased
% Summary
% Scaling:   Biased: Raw = Raw / N;   Unbiased: Raw = Raw / (N - lag) = Raw
% which means that when biased, the cross-covariance function are scaled, 
% or rather smoother, with smaller variance at end points.
figure
title('Biased & Unbiased');
Cuy_unbiased = xcov(y, u, 'unbiased');
subplot(211);plot(tau, Cuy); xlabel('\tau [s]'); ylabel('C_{uyBiased}');
subplot(212);plot(tau, Cuy_unbiased');xlabel('\tau [s]'); ylabel('C_{uyUnbiased}');


%% Task1.1.e Calculate the cross-correlation coefficient r_uu and r_uy
% Eauation: r_xx(tau) = C_xx(tau)./C_xx(0), r_uy = 
% Note that C_xx(tau) = variance of x at zero lag

% Summary
% We can get maximum cross-correlation coefficient when tau equals 0.
Ruu = Cuu ./ var(u);
Ruy = Cuy ./ (std(u) * std(y));
figure;
title('Cross-correlation coefficient');
subplot(211);plot(tau, Ruu); xlabel('\tau [s]'); ylabel('R_{uu}');
subplot(212);plot(tau, Ruy');xlabel('\tau [s]'); ylabel('R_{uy}');

%% Task1.1.f,g Write a cross-covariance function script
% Omitted

