clear all
close all

% Define constants
E = 70e9;
L = 7.5;
q_total = 2.5*500*0.5*9.8;   % given total load (scalar)

NumElements = 10:10:200;   % 20 values
sigmastar = zeros(length(NumElements), 1);

for k = 1:length(NumElements)
    Nelem = NumElements(k);
    
    % Set up problem
    xnodes = linspace(0, L, Nelem+1)';
    force = calc_load(xnodes, L, q_total);

    nvar = (Nelem+1)*2;
    r0 = zeros(nvar,1);
    r0(1:2:end) = 0.05;    % initial outer radius
    r0(2:2:end) = 0.0435;  % initial inner radius

    [zmax, ~] = get_radii(r0);
    Iyy = get_moment(r0);
    u = CalcBeamDisplacement(L, E, Iyy, force, Nelem);
    sigma = CalcBeamStress(L, E, zmax, u, Nelem);

    % Store max stress at tip
    star = abs(sigma(end));
    sigmastar(k) = (star/600e6);
end

figure;
plot(NumElements, sigmastar, 'bo-', 'LineWidth', 1.2);
xlabel('Number of Elements');
ylabel('\sigma^* (Pa)');
title('Stress vs. Number of Elements');
grid on;

xMargin = 0.05 * (max(NumElements) - min(NumElements));
yMargin = 0.05 * (max(sigmastar) - min(sigmastar));

xlim([min(NumElements)-xMargin, max(NumElements)+xMargin]);
ylim([min(sigmastar)-yMargin, max(sigmastar)+yMargin]);
