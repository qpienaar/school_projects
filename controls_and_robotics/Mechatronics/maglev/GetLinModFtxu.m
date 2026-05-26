function [A B] = GetLinModFtxu(ftxu, t, xs, us)
n = length(xs);
d = 1e-6;

for i = 1:n
    dx = zeros(n, 1);
    dx(i,1) = d;
    A(:, i) = (ftxu(t, xs+dx,us)-ftxu(t, xs-dx, us))/(2*d);
end    

m = length(us);
if (m==0)
    B=zeros(n, 1);
else
    for i=1:m
        du = zeros(m, 1);
        du(i, 1)=d;
        B(:, i) = (ftxu(t, xs, us+du) - ftxu(t, xs, us-du))/(2*d);
    end
end    