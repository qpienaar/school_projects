% MATLAB script to plot optimization convergence data.

% --- 1. Hardcode Data from data.txt ---

% Iteration numbers (0 to 12)
iterations = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12];

% Objective Function Value f(x)
% Data is from the 'f(x)' column in the log.
objective_value = [
    13.607;   % Iter 0 
    9.79041;  % Iter 1 [cite: 2]
    8.86645;  % Iter 2 [cite: 3]
    8.62305;  % Iter 3 [cite: 3]
    8.56511;  % Iter 4 [cite: 4]
    8.54611;  % Iter 5 [cite: 4]
    8.39912;  % Iter 6 [cite: 5]
    8.56851;  % Iter 7 [cite: 5]
    8.59795;  % Iter 8 [cite: 6]
    8.59684;  % Iter 9 [cite: 7]
    8.59574;  % Iter 10 [cite: 7]
    8.59568;  % Iter 11 [cite: 8]
    8.5957;   % Iter 12 [cite: 8]
];

% Maximum Constraint Violation (Max constraint)
% Data is from the 'Max constraint' column in the log.
max_constraint_violation = [
    0.9076;    % Iter 0 
    0.5506;    % Iter 1 [cite: 2]
    0.3232;    % Iter 2 [cite: 3]
    0.1829;    % Iter 3 [cite: 3]
    0.1814;    % Iter 4 [cite: 4]
    0.09888;   % Iter 5 [cite: 4]
    1.946;     % Iter 6 [cite: 5]
    0.5344;    % Iter 7 [cite: 5]
    0.3346;    % Iter 8 [cite: 6]
    0.1461;    % Iter 9 [cite: 7]
    0.008588;  % Iter 10 [cite: 7]
    6.843e-05; % Iter 11 [cite: 8]
    4.432e-09; % Iter 12 [cite: 8]
];

% First-order Optimality
% Data is from the 'First-order optimality' column in the log.
first_order_optimality = [
    NaN;   % Iter 0 (No value in log) 
    81.7;  % Iter 1 [cite: 2]
    38.3;  % Iter 2 [cite: 3]
    16;    % Iter 3 [cite: 3]
    19.1;  % Iter 4 [cite: 4]
    6.97;  % Iter 5 [cite: 4]
    16.9;  % Iter 6 [cite: 5]
    35.4;  % Iter 7 [cite: 6]
    27.5;  % Iter 8 [cite: 6]
    8.44;  % Iter 9 [cite: 7]
    2.54;  % Iter 10 [cite: 7]
    13.5;  % Iter 11 [cite: 8]
    2.89;  % Iter 12 [cite: 8]
];

% --- 2. Create the Figure and Subplots ---

% Create a figure window
figure('Name', 'Optimization Convergence', 'Position', [100, 100, 600, 700]);

% --- Plot 1: Objective Value ---
subplot(3, 1, 1);
plot(iterations, objective_value, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Objective Value');
ylabel('f(x)');
xlabel('Iteration');
grid on;

% --- Plot 2: Feasibility (Constraint Violation) ---
subplot(3, 1, 2);
% Plot in semilog scale (logarithmic y-axis)
semilogy(iterations, max_constraint_violation, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Feasibility (Semilog)');
ylabel('|Constraint Violation|');
xlabel('Iteration');
grid on;

% --- Plot 3: First-order Optimality ---
subplot(3, 1, 3);
% Plot in semilog scale (logarithmic y-axis)
% Note: The first data point (Iter 0) is NaN and will be skipped by plot.
semilogy(iterations, first_order_optimality, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('First-order Optimality (Semilog)');
ylabel('First-order Optimality');
xlabel('Iteration');
grid on;

% --- Adjust Subplots for better viewing ---
% Add vertical space between subplots
sgtitle('Optimization Convergence to an Optimal Design', 'FontWeight', 'bold');