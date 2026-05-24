function [Aineq, bineq, lb, ub] = ineq(r)
% Creates all constraint matrices
% Inputs:
% r - array containing the radii at each node
% Outputs:
% Aineq - Inequality matrix imposing spar thickness and stress values
% bineq - inequality array denoting what the minimum thickness and stress
% lb - lower bound for inner radius
% ub - upper bound for outer radius

nvar = length(r);
n = nvar/2;
nelem = n-1;

Aineq = zeros(nelem+1, nvar);
bineq = zeros(nelem+1, 1);

for i = 1:nelem+1
    index2 = i*2;
    index1 = index2 - 1;

    Aineq(i, index1) = -1;
    Aineq(i, index2) = 1;

    bineq(i) = -0.0025;
end

lb = zeros(nvar, 1);
ub = zeros(nvar, 1);

for j=1:2:nvar
    lb(j) = 0.00125;
    lb(j+1) = 0.01;

    ub(j) = 0.05;
    ub(j+1) = 0.0475;
end    