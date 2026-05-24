% Define parameter constants
alpha1 = 0.058;    % example value, adjust as needed
r2 = 0.8;          % example radius value
T = 7000;

% Create omega range (0 to 1 linearly spaced)
w = linspace(0.3, 1, 500);  
fvals = zeros(size(w));   % preallocate

% Evaluate f(w) for each omega
for i = 1:length(w)
    if w(i) == 0
        fvals(i) = NaN; % avoid divide-by-zero at w = 0
        fprintf('Calculation %d skipped. \n', i);
    else
        fvals(i) = obj(w(i), alpha1, r2, T);
        fprintf('Objective sample %d out of %d processed.\n', i, length(w));
    end
end


% Plot results
plot(w, fvals, 'LineWidth', 1.8)

