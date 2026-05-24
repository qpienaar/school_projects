function [cineq, ceq, Jineq, Jeq] = constrain(r, L, force, E, Nelem)
% Inputs:
% r: array of design variables
% L: length of spar
% x: node locations along spar
% q_total: total force on spar
% E: Young's Modulus
% Nelem: Number of elements
% Outputs:
% cineq: inequality constraint
% ceq: equality constraint --> not used
% Jineq: Jacobian inequality constraint transposed
% Jeq: Jacobian equality constraint transposed 

% ceq and Jeq not used
ceq = []; Jeq = [];

% Find cineq
cineq = subcon(r);

% Find Jineq
Jineq = zeros(size(r, 1), size(cineq, 1)); % dimensions are #dv x #constraints
h = 1e-30;
for i = 1:size(r, 1)
    rc = r;
    rc(i) = rc(i) + complex(0, h);
    Jineq(i, :) = imag(subcon(rc))/h;
end    

function [c] = subcon(dv)
[zmax, ~] = get_radii(dv);
Iyy = get_moment(dv);
u = CalcBeamDisplacement(L, E, Iyy, force, Nelem);
[sigma] = CalcBeamStress(L, E, zmax, u, Nelem);
sigmamax = 600e6;
c = (sigma./sigmamax) - 1;
end
end