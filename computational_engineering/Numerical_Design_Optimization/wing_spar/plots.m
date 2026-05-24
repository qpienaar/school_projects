clear; close all; clc;

% --- Data from fmincon output ---
data = [
    0   1   0.0382377   0             NaN      NaN      NaN;
    1   5   0.0245778  -0.00387      0.25   -0.289    0.028;
    2  10   0.01936     0.001447     0.125  -0.240    0.025;
    3  12   0.00412348  2.096        1.0    -0.226    0.00374;
    4  14   0.00459034  0.8137       1.0     0.0433   0.0151;
    5  16   0.00428975  0.208        1.0    -0.00405  0.011;
    6  18   0.00397026  0.1398       1.0    -0.00415  0.0102;
    7  20   0.0038504   0.03981      1.0    -0.00535  0.0113;
    8  23   0.00371195  0.04891      0.5    -0.00518  0.00782;
    9  25   0.00346828  0.2234       1.0    -0.00642  0.0118;
   10  27   0.00330512  0.09963      1.0    -0.0062   0.00777;
   11  29   0.00315602  0.04116      1.0    -0.00517  0.0043;
   12  31   0.00313757  0.06293      1.0    -0.00419  0.00153;
   13  33   0.00312515  0.05734      1.0    -0.00242  0.00237;
   14  35   0.00314414  0.005852     1.0     0.00286  0.00276;
   15  37   0.00314252  0.0004875    1.0    -0.000706 0.0022;
   16  39   0.00314019  1.081e-07    1.0    -0.00119  0.00178;
];

% --- Extract columns ---
Iter = data(:,1);
fx   = data(:,3);
MaxConstraint = data(:,4);
FirstOrderOpt = data(:,7);

% --- Create figure with three subplots ---
figure('Name','fmincon Optimization Progress','NumberTitle','off');

% --- Plot 1: f(x) ---
subplot(3,1,1);
plot(Iter, fx, '-o', 'LineWidth', 1.5, 'DisplayName', 'f(x)');
ylabel('f(x)');
title('Objective Function Value');
grid on;

% --- Plot 2: Max Constraint ---
subplot(3,1,2);
plot(Iter, MaxConstraint, '-s', 'LineWidth', 1.5, 'Color', [0 0.6 0], 'DisplayName', 'Max constraint');
ylabel('Max Constraint');
title('Constraint Violation');
grid on;

% --- Plot 3: First-Order Optimality ---
subplot(3,1,3);
plot(Iter, FirstOrderOpt, '-^', 'LineWidth', 1.5, 'DisplayName', 'First-order optimality');
ylabel('First-Order Opt.');
xlabel('Iteration');
title('First-Order Optimality');
grid on;

% --- Optional: Display final mass ---
mass = 5.0243; % from run_opt output
subplot(3,1,1);
text(max(Iter)*0.7, max(fx)*0.9, sprintf('Final Mass = %.3f kg', mass), ...
    'FontSize', 11, 'BackgroundColor', 'w', 'EdgeColor', 'k');

% --- Improve layout ---
sgtitle('fmincon Optimization Progress');
