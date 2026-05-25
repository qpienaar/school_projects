function xdot = rhs(t, x, u)

g = 9.81;
l = 0.019;      % segway: without battery
mp = 0.068;      % kg without batteries (does not include wheels)
mw = 0.034;      % verified 2 wheels and axle
rw = 0.022;      % 44/2 = radius of wheel in m (small wheel)
Iw = 1/2 * mw * rw^2;   % uniform disk
rm = 13;
kb = 0.155;
kt = 0.1;

Tm = (kt/rm)*(u+((kb/rw)*x(2))+(kb*x(4)));

xdot = zeros(4, 1);

xdot(1) = x(2);
xdot(3) = x(4);

alpha = x(3);
alphad = x(4);

% looking for alphadd xdot(4) and xdd xdot(2)

A = [0 0 0 0 0 1 1;
    -mw 0 0 -1 1 0 0;
    0 0 Iw rw 0 0 0;
    -mp mp*l*cos(alpha) 0 0 -1 0 0;
    0 mp*l*sin(alpha) 0 0 0 -1 0;
    0 0 0 0 -l*cos(alpha) -l*sin(alpha) 0;
    1 0 rw 0 0 0 0];

b = [mw*g;
    0;
    Tm;
    mp*l*(alphad^2)*sin(alpha);
    ((mp*g)-(l*(alphad^2)*cos(alpha)));
    Tm
    Tm];

z = A\b;

xdot(2) = z(1);
xdot(4) = z(2);
end