x0 = [0;0;210/180*pi;0]; u = 0.002; % assign initial conditions
[t, x] = ode45(@(t, x) rhs(t, x, u), [0 1], x0); 

pos = x(:, 1);
angle = x(:, 3);

plot(t, pos); 
hold on
plot(t, angle);

xlabel('Time (s)');

%yyaxis('left')
ylabel('Position m, Angle Rad')

%yyaxis('right')
%ylabel('Angle rad')

legend('x', 'angle');
%%
xs = [0;0;0;0]; us = 0;
[A, B] = GetLinModFtxu(@rhs, 0, xs, us)
%%

function xdot = rhs(t, x, u)

g = 9.81;
L = 0.019;      % segway: without battery
mp = 0.068;      % kg without batteries (does not include wheels)
mw = 0.034;      % verified 2 wheels and axle
rw = 0.02175;      % 44/2 = radius of wheel in m (small wheel)
Iw = 1/2 * mw * rw^2;   % uniform disk

xdot = zeros(4, 1);

xdot(1) = x(2);
xdot(3) = x(4);

A = [mw 0 0 1 -1 0;
    0 0 Iw rw 0 0;
    mp (-mp*L*cos(x(3))) 0 0 1 0;
    0 (-mp*L*sin(x(3))) 0 0 0 1;
    0 0 0 0 L*cos(x(3)) L*sin(x(3));
    1 0 rw 0 0 0];

b = [0;
    u;
    -mp*L*(x(4)^2)*sin(x(3));
    (mp*L*(x(4)^2)*sin(x(3))) - mp*g;
    -u;
    0];

z = A\b;

xdot(2) = z(1);
xdot(4) = z(2);
end