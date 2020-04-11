clear, clc, close all;

L = 128;
nfft = 4096;
h = hann(L);
x1 = exp(1j*0.5*pi*[0:L-1]');
x2 = exp(1j*0.51*pi*[0:L-1]');
x = x1 + x2;
H = fftshift(fft(x .* h, nfft));
H = H ./ max(H);

L = 1024;
h = hann(L);
x1 = exp(1j*0.5*pi*[0:L-1]');
x2 = exp(1j*0.51*pi*[0:L-1]');
x = x1 + x2;
H2 = fftshift(fft(x .* h, nfft));
H2 = H2 ./ max(H2);

w3dB = 2*pi*1.2/L; % from the table

figure
hold on
grid on
plot(linspace(-pi, pi, length(H)), abs(H), 'LineWidth', 3)
plot(linspace(-pi, pi, length(H2)), abs(H2), 'LineWidth', 3)
xlim([1 2])
xlabel('Frequency (rad/s)', 'interpreter', 'latex')
ylabel('Normalized Magnitude', 'interpreter', 'latex')
legend('Hann Window (L = 128)', 'Hann Window (L = 1024)', 'interpreter', 'latex')
set(gca, 'FontSize', 20, 'LineWidth', 3)