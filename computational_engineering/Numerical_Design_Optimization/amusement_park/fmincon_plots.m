% Optimization iteration data
Iter = [0 1 2 3 4 5 6]';
Fcount = [4 8 14 20 24 28 32]';
fval = [-1.48238 -3.89359 -4.61533 -4.64812 -4.65953 -4.66789 -4.6679]';
MaxConstraint = [-0.058 2.776e-17 0 0 0 0 0]';
StepLength = [NaN 1 0.25 0.25 1 1 1]';  % NaN for undefined initial step
DirectionalDerivative = [NaN -6.92 -9.72 -2.44 -1.72 -1.15 -0.025]';
FirstOrderOptimality = [NaN 12.7 12.3 2.56 0.821 0.0245 0.000403]';

%% Objective and optimality plots
figure;

% Objective value
subplot(3,1,1);
plot(Iter, fval, '-o');
xlabel('Iteration'); ylabel('f(x)');
title('Objective Value');
grid on;

% Feasibility (constraint violation)
subplot(3,1,2);
semilogy(Iter, abs(MaxConstraint), '-o');
xlabel('Iteration'); ylabel('|Constraint Violation|');
title('Feasibility (Semilog)');
grid on;

% First-order optimality
subplot(3,1,3);
semilogy(Iter, FirstOrderOptimality, '-o');
xlabel('Iteration'); ylabel('First-order optimality');
title('First-order Optimality (Semilog)');
grid on;

%% Separate constraint violation plot (optional)
figure;
plot(Iter, MaxConstraint, '-o');
xlabel('Iteration'); ylabel('Constraint Violation');
title('Constraint Violation (Linear Scale)');
grid on;
