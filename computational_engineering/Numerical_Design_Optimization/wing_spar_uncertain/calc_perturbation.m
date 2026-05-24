function delta = calc_perturbation(fnom, x, L)
% Inputs
%   fnom: scalar of the nominal force at the root
%   x: array of nodes to calculate delta at
%   L: total length of spar
% Outputs
%   delta: 1d array of the perturbation of force at each node
delta = zeros(length(x),1);
xi = zeros(4, 1);
for i = 1:4
    xi(i) = fnom/(10*i);
end

for j = 1:4
    uncertainty = xi(j)*cos(((2*j)-1)*pi*x/(2*L));
    delta = delta + uncertainty;
end