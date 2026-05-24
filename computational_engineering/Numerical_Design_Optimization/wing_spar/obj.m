function [f, g] = obj(r, L)
% This function calculates the total volume of the spar
% Inputs:
% r - vector containing all radii. Format is ri followed by ro
% L - length of spar
% Outputs:
% f - a scalar repersenting the total volume of the spar in m^3
% g - the gradient of the objective function

f = subobj(r);
g = zeros(size(r, 1), 1);
h = 1e-30;
for i = 1:size(r, 1)
    rc = r;
    rc(i) = rc(i) + complex(0, h);
    g(i) = imag(subobj(rc))/h;
end 

    function [fval] = subobj(dv)
        % This calculates the volume of the spar
        % Inputs: dv - the design variables, inner and outer radii of the
        % spar
        % Outpus:
        % fval - the volume
        [ro, ri] = get_radii(dv);
        volume = 0;
        dx = L / (length(ri)-1); % element length
        for j = 1:length(ri)
            area = pi * (ro(j)^2 - ri(j)^2);
            volume = volume + (area * dx);
        end
        
        fval = volume;
    end

end