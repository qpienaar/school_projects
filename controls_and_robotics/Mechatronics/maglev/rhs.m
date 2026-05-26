function xdot = rhs(t, x, u)
m = 0.00302; % mass of magnet
g = 9.81;
R = 3.39; % resistance of coil
L = 0.015; %inductance of the coil
k = 2.9626e-4;

xdot = zeros(3, 1);
xdot(1) = x(2);
xdot(2) = (1/m)*((m*g)-(k*((x(3)^2)/x(1)^2)));
xdot(3) = (1/L)*(u - R*x(3));
end