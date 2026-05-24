% This script determines the optimal value of T

% Simulate nominal design for a range of T
w = 6.5*2*pi/60;
alpha = 0.058;
r = 0.8;

T_values = linspace(1, 50000, 100); % Define a range of T values for simulation
performanceMetrics = zeros(size(T_values)); % Preallocate array for performance metrics

for i = 1:length(T_values)
    T = T_values(i);
    % Calculate performance metric for each T (example calculation)
    performanceMetrics(i) = obj(w, alpha, r, T);
    fprintf('Objective sample %d out of %d processed.\n', i, length(T_values));
end

plot(T_values, performanceMetrics);