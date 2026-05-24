function [f] = obj(w, alpha1, r2, T)
% This function calculates the objective function
% Inputs:
%   w: omega, the 
%   alpha1:
%   r2:
%   T = span of solution space
% Outputs:
%   sigma: The standard deviation of angular velocity dphi/dt

% define gamma, epsilon, alpha, beta
gamma = (1/(3*w))*((9.81/r2)^0.5);
Q0 = 20;
epsilon = 4.3/(9*r2);

% Inital conditions are [0, 0]
x0 = [0;0];
% Note we are in tau space not time space
[tau, x] = ode45(@(t, x) rhs(t, x), [0 T], x0);

% Find standard deviation
y1bar = (1/T)*(trapz(tau, x(:,2)));
integrand = (x(:, 2) - y1bar).^2;
I = trapz(tau, integrand);

f = 3*w*sqrt((1/T)*I);

function xdot = rhs(tau, x)
    % This function defines the state variables in ODE 27
    % Inputs:
    %   x: A vector containing states. x(1) = initial angle, x(2) = initial angular velocity
    % Outputs:
    %   xdot: First derivative of x

    alpha = 0.036 - (alpha1*cos(tau));
    beta = 3*alpha1*sin(tau);

    xdot = zeros(2, 1);
    xdot(1) = x(2);
    xdot(2) = -( ((gamma/Q0)*(x(2)))+((epsilon-(gamma^2*alpha))*(sin(x(1))))+(((gamma^2)*beta)*(cos(x(1)))) );
end
end