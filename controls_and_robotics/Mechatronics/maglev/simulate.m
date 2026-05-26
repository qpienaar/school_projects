%% magnet falling from 3 cm, no voltage
x0 = [.025;0; 0]; u = 0; % assign initial conditions
[t, x] = ode45(@(t, x) rhs(t, x, u), [0 .1], x0); % Note where u is passed into rhs
plot(t, x(:, 1)); % plot all state space vars or just some of them if desired
legend('z');
title('Magnet falling')
%% magnet from 3cm and 5 volts
x0 = [.025;0; 0.25]; u = 5; % assign initial conditions
[t, x] = ode45(@(t, x) rhs(t, x, u), [0 1], x0); % Note where u is passed into rhs
plot(t, x(:,1)); % plot all state space vars or just some of them if desired
legend('z');
title('magnet pulled towards solenoid')
%% Determine AB
xs = [0.025;0;0.25;]; us = 0.8475; % linearize about stable system
[A, B] = GetLinModFtxu(@rhs, 0, xs, us);
C = eye(length(A));
D = zeros(length(B), 1);

sys = ss(A, B, C, D);
G = tf(sys);
%% for simulations
r = [.001; 0; 0]; % deviation
u = 0.8475; % analytical stable voltage is 0.8745
xs = [0.025;0;0.25;];
%%
sim('lin_maglev.slx')
plot(t, x(:, 1))
%%
sim('nonlin_maglev.slx')
figure(1)
plot(t, x(:, 1))
title('position control')
%%
figure(2)
plot(t, unonlin);
title('Control effort')
%% Controller
num = [1 30];
den = [1 100];
k = -162.15;
C = tf(num, den);
Ts = .001;
Cd = c2d(C, Ts, 'tustin');
[numd, dend] = tfdata(Cd, 'v');
%% filter TF
tau = 1/(20*pi);
numf = [1];
denf = [tau 1];
F = tf(numf, denf);
Fd = c2d(F, Ts, 'tustin');
[numfd, denfd] = tfdata(Fd, 'v');