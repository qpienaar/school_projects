% This file runs the optimization algorithm

% set path for gpml
mydir = '/home/quintenpienaar/src/MATLAB/NumericalDesignOptimization/Project3/gpml-matlab-v3.6-2015-07-07/';
addpath(mydir(1:end-1))
addpath([mydir,'cov'])
addpath([mydir,'doc'])
addpath([mydir,'inf'])
addpath([mydir,'lik'])
addpath([mydir,'mean'])
addpath([mydir,'prior'])
addpath([mydir,'util'])

% Sample obj with LHS
N = 500; % number of samples[
dv = 3; % number of design variables
X = lhsdesign(N, dv);

% Scale dvs
X(:,1) = scale(X(:, 1), 0.314159, 0.837758); %omega
X(:, 2) = scale(X(:, 2), 0, 0.3); %alpha
X(:, 3) = scale(X(:, 3), 0.2, 1.5); %r2

% T TBD
T = 7000;

% Generate samples
sample = zeros(N, 1);
for i=1:N
    sample(i, 1) = obj(X(i, 1), X(i, 2), X(i, 3), T); % Obj samples 
    fprintf('Sample %d out of %d processed.\n', i, N);
end

close all
% Create surrogate
covfunc = @covSEiso;
likfunc = @likGauss;
sn = 0.1; % noise level
hyp.lik = log(sn);
hyp.cov = [log(0.3); log(0.75)]; % l = 0.3 sigma = 0.75
hyp.mean = []; % mean is 0
hyp = minimize(hyp, @gp, -100, @infExact, [], covfunc, likfunc, X,  sample);

% test surrogate 
z = [0, 0.058, 0.8];
w = linspace(0.3, 1, 100);   % 10 points from 0.3 to 1
y = zeros(size(w));           % preallocate y
for j = 1:length(w)
    z(1, 1) = w(j);
    y(j) = gp(hyp, @infExact, [], covfunc, likfunc, X, sample, z);
    fprintf('Surrogate sample %d out of %d processed.\n', j, length(w));
end

plot(w, y);
hold on
run('testing0bj.m');

xlabel('\omega (rad/s)')
ylabel('Standard Deviation of Angular Velocity)')
title('Objective Function and Surrogate')
legend('Surrogate Model', 'Objective function Sampling')
grid on
%% run optimization

% create lb and ub order is omega, alpha, r2
lb = [0.314159; 0; 0.1];
ub = [0.837758; 0.3; 1.5]; % upper bounds for omega, r2, alpha

z0 = [6.5*2*pi/60, 0.058, 0.8]; % initial guess for optimization - nominal values for now - should be a row vector

options = optimset('GradObj', 'off', 'GradConst', 'off', 'Display', 'iter', 'Algorithm', 'active-set'); % not providing gradient of objective or constraints
[x, fval] = fmincon(@(z)-gp(hyp, @infExact, [], covfunc, likfunc, X, sample, z), z0, [], [], [], [], lb, ub, [], options);

