% minimize wing spar weight subject to stress constraints at manuever
clear all;
close all;

% carbon fiber values from http://www.performance-composites.com/carbonfibre/mechanicalproperties_2.asp
Nelem = 70;
L = 7.5; % semi-span in meters
rho = 1600; % density of standard carbon fiber, kg/m^3
yield = 600e6; % tensile strength of standard carbon fiber, Pa
E = 70e9; % Young's modulus, Pa
W = 0.5*500*9.8; % half of the operational weight, N
force = (2*(2.5*W)/(L^2))*[L:-L/Nelem:0].'; % loading at manueuver
fnom = force(1, 1);
x = [0:L/Nelem:L].';
pts= 2;

% define function and constraints
fun = @(r) SparWeight(r, L, rho, Nelem);
nonlcon = @(r) WingConstraints(r, L, E, force, yield, Nelem, fnom, x, pts);
lb = 0.01*ones(2*(Nelem+1),1);
up = 0.05*ones(2*(Nelem+1),1);
A = zeros(Nelem+1,2*(Nelem+1));
b = -0.0025*ones(Nelem+1,1);
for k = 1:(Nelem+1)
    A(k,k) = 1.0;
    A(k,Nelem+1+k) = -1.0;
end

% define initial guess (the nominal spar)
r0 = zeros(2*(Nelem+1),1);
r0(1:Nelem+1) = 0.04625*ones(Nelem+1,1);
r0(Nelem+2:2*(Nelem+1)) = 0.05*ones(Nelem+1,1);

options = optimset('GradObj','on','GradConstr','on', 'TolCon', 1e-4, ...
    'TolX', 1e-8, 'Display','iter', 'Algorithm', 'active-set'); %, 'DerivativeCheck','on');
[ropt,fval,exitflag,output] = fmincon(fun, r0, A, b, [], [], lb, up, ...
    nonlcon, options);

% display weight and stress constraints
[f,~] = fun(ropt)
[c,~,~,~] = nonlcon(ropt)
%%
% plot optimal radii
r_in = ropt(1:Nelem+1);
r_out = ropt(Nelem+2:2*(Nelem+1));
figure
plot(x, r_in, '-ks');
hold on;
plot(x, r_out, '--ks');
plot(x, r_in);
plot(x, ro);
title('Optimal Geometry')
xlabel('Distance along spar (m)');
ylabel('Height (m)');
legend('Variable Stress Inner Radius', 'Variable Stress Outer Radius', 'Deterministic Stress Inner Radius', 'Deterministic Stress Outer Radius')

% plot stress
Iyy = CalcSecondMomentAnnulus(r_in, r_out);
[muopt, sigmaopt] = calc_statistic(fnom, x, L, E, Iyy, force, Nelem, r_out, 2);
figure
plot(x, muopt);
hold on
plot(x, muopt+(6*sigmaopt));
plot(x, muopt-(6*sigmaopt));
plot(x, stressopt);
title('Stress Along Spar');
xlabel('Distance along spar (m)');
ylabel('Height (m)');
legend('Mean Variable Stress', 'Mean Plus 6 Standard Deviations', 'Mean Minus 6 Standard Deviations', 'Deterministic Stress')