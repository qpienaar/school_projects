function Iyy = get_moment(r)
% Find moment of inertia of spar at each node
% Inputs:
% r - The radius at each node. Format is [ri1 ro1 ri2 ro2 ... rin ron]'
% Outputs:
% Iyy - The moment of inertia at each node

[ro, ri] = get_radii(r);
Iyy = zeros(size(ri, 1), 1);
tol = 1e-10;
for i = 1:length(ri)
    D = ro(i)*2;
    d = ri(i)*2;
    Iyy(i) = (D^4 - d^4)*(pi/64);
    if real(Iyy(i)) < tol
        Iyy(i) = tol;
    end
end    