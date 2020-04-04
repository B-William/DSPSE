clear, clc, close all;

L = 3; % equalizer length
h = [1; -1]; % channel impulse response
x = randsrc(100, 1, [1, 0, -1; 0.3, 0.4, 0.3]);

H = convmtx(h, L);
Hp = pinv(H);

d = zeros(size(Hp, 2), 1);
d(1) = 1;

f = Hp*d;

y = conv(h, x); % received signal
z = conv(f, y); % signal after ZF equalizer

figure
subplot(3, 1, 1)
stem(x)
title('Transmitted Signal')
subplot(3, 1, 2)
stem(y)
title('Received Signal')
subplot(3, 1, 3)
stem(z)
title('After ZF Equalizer')

figure
stem(conv(h, f))
title('This should look "like" an impulse')

nfft = 128;
H = fftshift(fft(h, nfft));
F = fftshift(fft(f, nfft));
w = linspace(-pi, pi, nfft);

figure
hold on
grid on
plot(w, abs(H))
plot(w, abs(F))
plot(w, abs(1./H))
xlabel('Frequency (radians)')
ylabel('Magnitude')
legend('Channel Response', 'ZF Equalizer', 'True ZF Equalizer')