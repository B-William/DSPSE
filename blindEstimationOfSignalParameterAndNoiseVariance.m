% https://dsp.stackexchange.com/questions/65932/blind-estimation-of-signal-parameter-and-noise-variance/65942#65942

clear, clc, close all;

SNR_dB = 10;
N = 1000;

hMag = rand(1);
hPhase = pi*(rand(1) - 0.5);
h = hMag*exp(1j*hPhase);

x = 2*randi([0, 1], N, 1)-1;
powerX = var(h*x);
powerNoise = powerX/10^(SNR_dB/10);
noise = sqrt(powerNoise/2)*(randn(size(x)) + 1j*randn(size(x)));
y = h*x + noise;

% Processing to estimate h and noise variance
y2 = y.^2;
data = [real(y), imag(y)];
idx = kmeans(data, 2);

% Noise variance estimate
noisePowerHat = (var(y(idx == 1) - mean(y(idx == 1))) + var(y(idx == 2) - mean(y(idx == 2))))/2;

% Phase estimate
angleY2 = angle(y2);
shift = max(abs(angleY2));
angleY2 = angleY2 + shift;
hPhaseHat = (mean(angleY2) - shift)/2;

% Magnitude estimate
hMagHat = sqrt(abs(mean(y2)) - noisePowerHat);
hHat = hMagHat*exp(1j*hPhaseHat);

% Reverse the effect of h
r = y ./ hHat;

% Plot the result
figure, hold on, grid on, scatter(real(y), imag(y), 80, '.')
scatter(real(r), imag(r), 80, 'k.')
scatter(real(x), imag(x), 80, 'r+', 'LineWidth', 2)
xlim([-1.5 1.5]), ylim([-1 1])
legend('Received Signal', 'After Correction', 'Original x[n]', 'interpreter', 'latex')
xlabel('Real', 'interpreter', 'latex')
ylabel('Imaginary', 'interpreter', 'latex')
set(gca, 'FontSize', 20, 'TickLabelInterpreter', 'latex')