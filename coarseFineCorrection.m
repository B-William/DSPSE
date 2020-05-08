% https://dsp.stackexchange.com/questions/67170/how-to-compensate-for-frequency-offset-in-single-carrier-transmission-using-coar/67221#67221
clear, clc, close all;

%% Parameters and data generation
M = 4;
N = 256;
phaseOffset = 0.01*pi;
rolloff = 0.25;
span = 6;
sps = 10;
p = rcosdesign(rolloff, span, sps, 'sqrt');
s = pskmod(randi([0, M-1], N, 1), M) .* exp(1j*phaseOffset*[0:N-1]');
x = awgn(s, 20, 'measured');

%% Coarse estimate
nfft = length(x);
X = fftshift(fft(x.^M, nfft));
wAxis = 2*pi*linspace(-0.5, 0.5, nfft);
[~, maxInd] = max(abs(X));
coarseEstimate = wAxis(maxInd)/M;
coarseCorrected = exp(-1j*coarseEstimate*[0:length(x)-1]') .* x;

%% Fine estimate
stepSize = 0.001*2*pi/nfft;
curPhase = M*coarseEstimate;
minStepSize = 1e-10;
done = false;
k = 1;
maxIter = 1000;
while ~done && k <= maxIter
   curVal = abs(mean(exp(-1j*curPhase(k)*[0:length(x)-1]') .* x.^M));
   nextPhase = curPhase(k) + stepSize(k);
   nextVal = abs(mean(exp(-1j*nextPhase*[0:length(x)-1]') .* x.^M));
   grad(k) = (nextVal - curVal)/stepSize(k);
   curPhase(k + 1) = curPhase(k) + stepSize(k)*grad(k);
   if abs(curPhase(k+1)-curPhase(k)) < 1e-6
      done = true;
   elseif stepSize >= minStepSize
      stepSize(k + 1) = stepSize(k)*0.99;
   else
      stepSize(k + 1) = minStepSize;
   end
   
   k = k + 1;
end
fineEstimate = curPhase(end)/M;
fineCorrected = exp(-1j*fineEstimate*[0:length(x)-1]') .* x;

%% Plot the results
figure
hold on
grid on
scatter(real(coarseCorrected), imag(coarseCorrected), 100, '.')
scatter(real(fineCorrected), imag(fineCorrected), 100, '.')
xlabel('In-Phase', 'interpreter', 'latex')
ylabel('Quadrature', 'interpreter', 'latex')
legend('After Coarse Correction', 'After Fine Correction', 'interpreter', 'latex')
set(gca, 'FontSize', 20, 'LineWidth', 3)

figure
hold on
grid on
plot(1:k, curPhase/M, 'LineWidth', 3)
pTrue = plot([1, k], [phaseOffset, phaseOffset], 'LineWidth', 3);
legend([pTrue], {'True Phase Offset'}, 'interpreter', 'latex')
xlabel('Iteration', 'interpreter', 'latex')
ylabel('Frequency Offset Estimate', 'interpreter', 'latex')
set(gca, 'FontSize', 20, 'LineWidth', 3)

figure
hold on
grid on
plot(2*pi*linspace(-0.5, 0.5, 128*nfft), abs(fftshift(fft(x.^M, 128*nfft))), 'LineWidth', 3)
plot(wAxis, abs(X), 'LineWidth', 3)
plot([coarseEstimate*M], [max(abs(X))], 'O', 'LineWidth', 3)
xlabel('$\omega$ (rad/s)', 'interpreter', 'latex')
ylabel('Magnitude', 'interpreter', 'latex')
set(gca, 'FontSize', 20, 'LineWidth', 3)
legend('Interpolated FFT', 'FFT Used in Coarse Step')
axis tight