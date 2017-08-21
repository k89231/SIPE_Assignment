clear all;
close all;
%% Get the datum, 10 secs case
sim('..\sim\LinearWhiteNoise', [0, 10]);
N = 1000;                  % # samples
t10 = u.Time(1:N);
u10 = u.Data(1:N);
y10 = y.Data(1:N);
dt = 0.01;
whos
[Cuy10_b, lag10] = xcov(y10, u10, 'biased');
Cyu10_b = xcov(u10, y10, 'biased');
Cuu10_b = xcov(u10, u10, 'biased');
Cyy10_b = xcov(y10, y10, 'biased');
Cuy10_un = xcov(y10, u10, 'unbiased');
Cyu10_un = xcov(u10, y10, 'unbiased');
Cuu10_un = xcov(u10, u10, 'unbiased');
Cyy10_un = xcov(y10, y10, 'unbiased');
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
plot(tau10, Cuy10_b/dt, 'g');hold on;
plot(tau100, Cuy100/dt, 'b');hold on;
xlabel('\tau [s]');title('10s & 100s Cross-Covariance fcn & Impulse Function');
legend({'Theoretical impulse response', '10s Estimation', '100s Estimation'});
% Remember the scaling part '1/dt', cuz the numerator
% 1/N; in continuous cases it should be 1/T


%% Task2.j Use the command of fftshift to transform auto/cross-covariant
% functions into auto/cross-spectral densities.

% We choose fftshift&fft rather than fft cuz the center of the sequence has to
% be shifted.
N = 1000;                           % 10 secs
% First : Shift the frequency axis.
Cuu10_b = fftshift(Cuu10_b/dt);
Cuy10_b = fftshift(Cuy10_b/dt);
Cuu10_un = fftshift(Cuu10_un/dt);
Cuy10_un = fftshift(Cuy10_un/dt);
% Second : DFT
f = (1/dt) * (0:.5:N-1) / N;        % N*df=1/dt, The length of the f-axis is
Suu10_b = fft(Cuu10_b);             % twice as long.
Suy10_b = fft(Cuy10_b);
Suu10_un = fft(Cuu10_un);
Suy10_un = fft(Cuy10_un);

figure;subplot(211);
loglog(f, abs(Suu10_b), 'r');hold on;
loglog(f, abs(Suu10_un), 'g');hold on;
xlabel('f [Hz]');title('Suu');legend({'SuuBiased','SuuUnbiased'});

subplot(212);
loglog(f, abs(Suy10_b), 'r');hold on;
loglog(f, abs(Suy10_un), 'g');hold on;
xlabel('f [Hz]');title('Suy');legend({'SuyBiased','SuyUnbiased'});

%% Task 1.4.p Prove that Suy(w)=G(w).*Suu(w)
f1 = f * 1i;
G = 1./(0.025*(f1.^2+0.015*f1+1)); G=G';
figure;
subplot(211);loglog(f, abs(Suu10_b.*G), 'g');
subplot(212);loglog(f, abs(Suy10_b), 'b');