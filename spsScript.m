clear, clc, close all;

rolloff = 0.25;
span = 6;
sps = 2:2:10;
maxLength = span*max(sps) + 1;

figure
hold on
grid on
for k = 1:length(sps)
   p = rcosdesign(rolloff, span, sps(k), 'sqrt');
   n = linspace(0, maxLength, length(p));
   plot(n, p, 'o-', 'LineWidth', 2)
end

xlabel('Sample Index', 'interpreter', 'latex')
ylabel('Amplitude', 'interpreter', 'latex')
legend('sps = 2', 'sps = 4', 'sps = 6', 'sps = 8', 'sps = 10', 'interpreter', 'latex');
set(gca, 'FontSize', 20, 'LineWidth', 2, 'TickLabelInterpreter', 'latex', 'FontWeight', 'Bold')
