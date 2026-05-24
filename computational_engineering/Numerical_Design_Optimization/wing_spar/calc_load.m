function [qx] = calc_load(x, L, q_total)
% Calculates load at each x node on spar
% Inputs:
% x: array of node locations
% L: scalar length of spar
% q_total: total load on spar
% Outputs:
% qx: load at each x element

% maximum load at root
qmax = q_total*2/L;
%slope
m = -qmax/L;
qx = zeros(size(x, 1), 1);
for i = 1:size(x, 1)
    qx(i) = subcalc(x(i));
end    

function y = subcalc(x)
y = (m*x)+qmax;
end
end