%intialize
fexp = -1:.01:4;
f = 10.^fexp;
magnitude = zeros(size(f));
phase = zeros(size(f));
for i = 1:length(f)
    %collect data
    T = 1/f(i);
    t = 0:T/10000:20*T; 
    in = sin(2*pi*f(i)*t);
    out = sensor1(in, t);
    %find output peaks
    [pkso, locso] = findpeaks(out);
    [pksi, locsi] = findpeaks(in);
    Mlast_outpeak = pkso(end); Tlast_outpeak = locso(end);
    Mlast_inpeak = pksi(end); Tlast_inpeak = locsi(end);
    %calculate magnitude and phase shift
    magnitude(i) = 20*log10(Mlast_outpeak/Mlast_inpeak);
    dt = (t(Tlast_inpeak)-t(Tlast_outpeak));
    phase(i) = dt*f(i)*360;
end
%% 
s = tf('s');
% k = 1;
% G = k * ((1/210.5)*s+1)/((1/157.5)*s + 1);
G = tf(4, 1);

% Evaluate Bode data of G over your frequency range
w = 2*pi*f;  % convert Hz to rad/s
[magG, phaseG] = bode(G, w);
magG = squeeze(magG);        % magnitude in absolute
phaseG = squeeze(phaseG);    % phase in degrees
magG_dB = 20*log10(magG);     % convert to dB

% Plot both Bode diagrams
figure;

% Magnitude plot
subplot(2,1,1);
semilogx(f, magnitude, 'b', 'LineWidth', 1.5); hold on;
semilogx(f, magG_dB, 'r--', 'LineWidth', 1.5);
%ylim([-5 1])
grid on;
ylabel('Magnitude (dB)');
title('Bode Diagram, ((1/210)*s+1)/((1/157)*s + 1);');
legend('Measured', 'G(s)', 'Location', 'Best');

% Phase plot
subplot(2,1,2);
semilogx(f, phase, 'b', 'LineWidth', 1.5); hold on;
semilogx(f, phaseG, 'r--', 'LineWidth', 1.5);
grid on;
ylabel('Phase (degrees)');
xlabel('Frequency (Hz)');
legend('Measured', 'G(s)', 'Location', 'Best');