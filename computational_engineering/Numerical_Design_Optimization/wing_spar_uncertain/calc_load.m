function [mu, stdv] = calc_load(force, x, L)
% Inputs:
%   force: nominal load at each node  (Nx1)
%   delta: perturbation std at each node (Nx1)
% Outputs:
%   mu:   mean force at each node
%   stdv: standard deviation at each node

    delta = calc_perturbation(force(1, 1), x, L);

    % 3-point Gauss–Hermite nodes and weights
    GH_xi  = [-1.22474487139; 0.0; 1.22474487139];
    GH_wts = [0.29540897515; 1.18163590006; 0.29540897515] ./ sqrt(pi);

    N = length(force);

    mu   = zeros(N,1);
    stdv = zeros(N,1);

    for i = 1:N
        fvals = zeros(3,1);

        % Evaluate the load model at Gauss–Hermite points
        for k = 1:3
            Fk = force(i) + delta(i)*GH_xi(k);
            fvals(k) = Fk;
        end

        % Mean via quadrature
        mu(i) = sum(GH_wts .* fvals);

        % Second moment
        m2 = sum(GH_wts .* (fvals.^2));

        % Std deviation
        stdv(i) = sqrt(m2 - mu(i)^2);
    end
end
