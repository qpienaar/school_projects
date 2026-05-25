%% Determine k
xs = [0;0;0;0]; us = 0.00; % linearize about stable system
[A, B] = GetLinModFtxu(@rhs, 0, xs, us);
C = eye(length(A));
D = zeros(length(B), 1);
%%
Q = [1 0 0 0;
    0 .01 0 0;
    0 0 1 0;
    0 0 0 .1];
%Q = Q.*100;
R = 1;
k = lqr(A, B, Q, R);
%%  Simulate without integration
r = [0;0;0;0];
u = 0.0;
%%
%sim('linmodel.slx')
sim('nonlinmodel')

%pos1 = x(:, 1);
%angle1 = x(:, 3);

pos2 = x1(:, 1);
angle2 = x1(:, 3);

%plot(t, pos1);
%hold on
plot(t1, pos2);
hold on

%plot(t, angle1);
plot(t1, angle2);
legend('Displacement', 'Angle')

%legend('Linear Pos','Non linear Pos', 'Linear Angle', 'Nonlinear Angle');

%% determine k adressing position steady state error
Aint = [A zeros(4,1); 
        1 0 0 0 0];
Bint = [B;0];
Cint = eye(length(Aint));
Dint = zeros(length(Bint), 1);

Qint = eye(length(Aint));
R = 1;
kint = lqr(Aint, Bint, Qint, R);
rint = [0;0;deg2rad(10);0;0];

%% simulate with integration
sim('linmodel_int.slx')
% Extract the results from the simulation
posInt = linx_int(:, 1);
angleInt = linx_int(:, 3);

% Plot the results of the integrated simulation
figure;
plot(lint_int, posInt, 'r--');
hold on;
plot(lint_int, angleInt, 'g-.');
xlabel('Time (s)');
ylabel('Position and Angle');
grid on;