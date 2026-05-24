    function[mu, sigma] = calc_statistic(fnom, x, L, E, Iyy, force, Nelem, zmax, pts)
    % Inputs:
    %   fnom: scalar value repersenting nominal stress
    %   x: array of locations of nodes
    %   E: YM
    %   Iyy: MOI
    %   force: Array of nominal force along spar
    %   Nelem: Number of elements
    %   zmax: array of maximum radius of spar
    %   pts: scalar repersenting number of GHQ points to use
    % Outputs:
    %   mu: array of mean stress
    %   sigma: array of standard deviations
    
    % define RVs
    sigma1 = fnom/10;
    sigma2 = fnom/20;
    sigma3 = fnom/30;
    sigma4 = fnom/40;
    
    if pts == 1
        xi = [0.0];
        wts = [1.772453850906]./ sqrt (pi);
    end
    
    if pts == 2
        xi = [-0.707106781186548; 0.707106781186548];
        wts = [0.8862269254528; 0.8862269254528]./ sqrt (pi);
    end
    
    if pts == 3
        xi = [ -1.22474487139; 0.0; 1.22474487139];
        wts = [0.295408975151; 1.1816359006; 0.295408975151]./ sqrt (pi); % adjusted weights!
    end

    if pts == 4
        xi = [-1.650680123885785; -0.524647623275290; 0.524647623275290; 1.650680123885785];
        wts = [0.8049140900055; 0.08131283544725; 0.8049140900055; 0.08131283544725]./ sqrt (pi);
    end

    if pts == 5
        xi = [ -2.020182870456086;
               -0.958572464613819;
                0.000000000000000;
                0.958572464613819;
                2.020182870456086 ];
    
        wts = [0.01995324205905;
               0.3936193231522;
               0.9453087204829;
               0.3936193231522;
               0.01995324205905] ./ sqrt(pi);
    end

    if pts == 6
        xi = [ -2.350604973674492;
               -1.335849074013697;
               -0.436077411927617;
                0.436077411927617;
                1.335849074013697;
                2.350604973674492 ];
    
        wts = [0.004530009905509;
               0.1570673203229;
               0.7246295952244;
               0.7246295952244;
               0.1570673203229;
               0.004530009905509] ./ sqrt(pi);
    end

    mu = 0;
    Ef2 = 0;

    for i1 = 1:size(xi, 1) % for rv 1
        pt1 = sqrt(2)*sigma1*xi(i1);
        for i2 = 1:size(xi, 1) % for rv 2
            pt2 = sqrt(2)*sigma2*xi(i2);
            for i3 = 1:size(xi, 1) % for rv 3
                pt3 = sqrt(2)*sigma3*xi(i3);
                for i4 = 1:size(xi, 1) % for rv 4
                    pt4 = sqrt(2)*sigma4*xi(i4);
    
                    f = force + delta(pt1, 1) + delta(pt2, 2) + delta(pt3, 3) + delta(pt4, 4);
                    u = CalcBeamDisplacement(L, E, Iyy, f, Nelem);
                    s = CalcBeamStress(L, E, zmax, u, Nelem);

                    w = wts(i1)*wts(i2)*wts(i3)*wts(i4);

                    mu = mu + w * s;
                    Ef2 = Ef2 + w * (s.^2);
                end
            end
        end
    end
    sigma = sqrt(Ef2 - mu.^2);
    
    function d = delta(xi, n)
        d = xi*cos(((2*n-1)*x*pi)/(2*L));
    end
    
    end