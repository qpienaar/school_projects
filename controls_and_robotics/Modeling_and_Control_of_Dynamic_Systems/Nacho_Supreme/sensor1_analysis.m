ti1 = 0:0.001:1; % Time [s]

% Apply a sinusoidal input
f = 10;  % Frequency in Hz
u2 = sin(2*pi*f*ti1); 
[y2, to2] = sensor1(u2, ti1);

% Plotting input-output for sinusoidal input
figure(1)
hold on
plot(ti1, u2, 'k') % Sinusoidal input
plot(to2, y2, 'g') % Sinusoidal output
hold off
legend('Sinusoidal Input', 'Sinusoidal Output')
xlabel('Time (s)')
ylabel('Amplitude')
title('Sinusoidal Input and Output Signals')

% FFT Calculation for Sinusoidal Input-Output
n = length(y2);  % Number of samples
Fs = 1 / (ti1(2) - ti1(1));  % Sampling frequency
f = (0:n-1) * (Fs/n);  % Frequency vector

% FFT of input and output for sinusoidal response
input_fft_sin = fft(u2);
output_fft_sin = fft(y2);

% Calculate the transfer function in frequency domain (output / input)
H_sin = output_fft_sin ./ input_fft_sin;

% Calculate magnitude
magnitude_sin = abs(H_sin);

% Convert to dB
magnitude_sin_dB = 20 * log10(magnitude_sin);

% Calculate phase (in radians)
phase_sin = angle(H_sin);  % Phase in radians
phase_sin_deg = phase_sin * (180 / pi);  % Convert to degrees

% Plot Bode Magnitude and Phase (in dB and degrees) for sinusoidal input
figure(2)
% Magnitude Plot
subplot(2,1,1)
semilogx(f(1:n/2), magnitude_sin_dB(1:n/2), 'g', 'LineWidth', 1.5)  % Sinusoidal input-output
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Bode Magnitude Plot (Sinusoidal Input)')
grid on;

% Phase Plot
subplot(2,1,2)
semilogx(f(1:n/2), phase_sin_deg(1:n/2), 'g', 'LineWidth', 1.5)  % Sinusoidal input-output
xlabel('Frequency (Hz)')
ylabel('Phase (Degrees)')
title('Bode Phase Plot (Sinusoidal Input)')
grid on;