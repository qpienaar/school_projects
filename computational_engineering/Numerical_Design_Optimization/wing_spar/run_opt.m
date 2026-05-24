clear all
close all

% define variables
Nelem = 70;
nvar = (Nelem+1)*2;
E = 70e9;
L = 7.5;
q_total = 2.5*500*0.5*9.8;   % given total load (scalar)
xnodes = linspace(0, L, Nelem+1)';
force = calc_load(xnodes, L, q_total);

%define inital design
r0 = zeros(nvar,1);
r0(1:2:end) = 0.05; % initial outer radius
r0(2:2:end) = 0.03; % initial inner radius

% define constraints
[Aineq, bineq, lb, ub] = ineq(r0);

%fmincon
options = optimset('GradObj', 'on', 'GradConst', 'on', 'Display', 'iter', 'Algorithm', 'active-set');
[x, fval] = fmincon(@(r)obj(r, L), r0, Aineq, bineq, [], [], lb, ub, @(r)constrain(r, L, force, E, Nelem), options);
[ro, ri] = get_radii(x);

figure
plot(xnodes, ri);
mass = fval*1600;
hold on
plot(xnodes, ro);
legend('Inner radius', 'Outer radius')

% plot stress
Iyy = get_moment(x);
uopt = CalcBeamDisplacement(L, E, Iyy, force, Nelem);
stressopt = CalcBeamStress(L, E, ro, uopt, Nelem);
figure
plot(xnodes, stressopt);