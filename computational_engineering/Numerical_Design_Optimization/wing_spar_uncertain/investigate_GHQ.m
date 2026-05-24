% The purpose of this script is to determine the ideal number of GHQ points
% carbon fiber values from http://www.performance-composites.com/carbonfibre/mechanicalproperties_2.asp
Nelem = 15;
L = 7.5; % semi-span in meters
E = 70e9; % Young's modulus, Pa
W = 0.5*500*9.8; % half of the operational weight, N
force = (2*(2.5*W)/(L^2))*[L:-L/Nelem:0].'; % loading at manueuver
fnom = force(1, 1);
x = [0:L/Nelem:L].';

% define initial guess (the nominal spar)
r0 = zeros(2*(Nelem+1),1);
r0(1:Nelem+1) = 0.04625*ones(Nelem+1,1);
r0(Nelem+2:2*(Nelem+1)) = 0.05*ones(Nelem+1,1);
r_in = r0(1:Nelem+1);
r_out = r0(Nelem+2:2*(Nelem+1));
Iyy = CalcSecondMomentAnnulus(r_in, r_out);

% Convergence plot of number of GHQ
mus = zeros(1, 6);
sigmas = zeros(1, 6);
for i = 1:6
    pts = i;
    [mu, sigma] = calc_statistic(fnom, x, L, E, Iyy, force, Nelem, r_out, pts);
    mus(1, i) = mu(1, 1);
    sigmas(1, i) = sigma(1, 1);
end

xaxis = [1 2 3 4 5 6];

figure; hold on;

% Mean: black line with circle markers
plot(xaxis, mus, '-ok', ...      % black line, circle markers
     'LineWidth', 1.5, ...
     'MarkerSize', 6, ...
     'MarkerFaceColor', 'k');    % filled markers

% Std-dev: gray line with square markers
plot(xaxis, sigmas, '-sk', ...   % temporarily black for shape
     'Color', [0.5 0.5 0.5], ... % convert to gray
     'LineWidth', 1.5, ...
     'MarkerSize', 6, ...
     'MarkerFaceColor', [0.5 0.5 0.5]); % filled gray markers

legend('Mean', 'Standard Deviation');
xlabel('Number of GHQ Points');
ylabel('Values');
title('Convergence of GHQ Points');
grid on;
