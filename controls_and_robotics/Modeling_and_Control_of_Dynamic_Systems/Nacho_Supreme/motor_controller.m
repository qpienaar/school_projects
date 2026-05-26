%motor & load dynamics
s = tf('s');
G1 = 1/(.04e-3*s + 4);
K1 = 34.7e-3/3;
H1 = 1/((3.7e-8+2.62e-6)*s + (2e-4+3.76e-4));
K2 = 12/(2*pi*10000/60);

%general motor dynamics tf
Gm = G1*K1/(1+G1*K1*H1*K2);
%sensor 1 -> divided by k1 due to moving pickoff point upstream
sensor1 = 4/K1;
%inverted pendulum
Gp = 2833/(s^2-189.4);
%sensor 2
sensor2 = ((1/210.5)*s+1)/((1/157.5)*s + 1);
%Motor controller
C2 = 1190.9/s;
%Attitude Control
C1 = 14.753*(s+12.23)*(s+1.822)/s;

%inner loop
Gloop1 = C2*Gm/(1+C2*Gm*sensor1);
%system
overall_system = C1*Gloop1*Gp/(1+C1*Gloop1*Gp*sensor2);
%plotting
step(overall_system)
title('Step Response from Script')
info = stepinfo(overall_system)
%% 
figure(2)
bode(overall_system)
title('System Bode Diagram - Quinten Pienaar')
grid on
%% 
figure(3)
rlocus(overall_system);
title('Root Locus Plot');
xlabel('Real Axis');
ylabel('Imaginary Axis');
grid on;