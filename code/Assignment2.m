clear all;
close all;
%% Get the datum, 10 secs case
sim('LinearWhiteNoise', [0, 10]);
N = 1000;                  % # samples
t10 = u.Time(1:N);
u10 = u.Data(1:N);
y10 = y.Data(1:N);
dt = 0.01;
whos
[Cuy10, lag10] = xcov(y10, u10, 'biased');
tau10 = lag10 * dt;
%% Get the datum, 100 secs case
% Expect a lower variance at higer tau
sim('LinearWhiteNoise', [0, 100]);
N = 10000;                  % # samples
t100 = u.Time(1:N);
u100 = u.Data(1:N);
y100 = y.Data(1:N);
%dt = 0.01;
whos
[Cuy100, lag100] = xcov(y100, u100, 'biased');
tau100 = lag100 * dt;
%% Task2.i Compare the cross-covariance function & impulse response
% Summary
% - The cross-covariance function resembles impulse function in some way.
% - More sampling time, less variance with estimation.
figure
sys1 = tf([1], [0.0025 0.015 1]);
[y_theo, t_theo] = impulse(sys1);
plot(t_theo, y_theo, 'r'); hold on;
plot(tau10, Cuy10/dt, 'g');hold on;
plot(tau100, Cuy100/dt, 'b');hold on;
xlabel('\tau [s]');title('10s & 100s Cross-Covariance fcn & Impulse Function');
legend({'Theoretical impulse response', '10s Estimation', '100s Estimation'});
% Remember the scaling part '1/dt', cuz the numerator
% 1/N; in continuous cases it should be 1/T


