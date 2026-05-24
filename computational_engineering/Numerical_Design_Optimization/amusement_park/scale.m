function y = scale(x, lb, ub)
% This function scales a design variable
% Inputs:
%   ub - Upper bound of design variable
%   lb - Lower bound of design variable
%   x - An array containing the values to be scaled
% Outputs:
%   y - An array containing the scaled DV

y = x .* (ub - lb) + lb;
