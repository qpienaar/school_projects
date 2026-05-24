function [ro, ri] = get_radii(r)
% This function extracts the inner and outer radii from a vector of all
% radii. It assumes that radii are listed in pairs with the inner radii listed before the outer
% inputs:
% r - a vector containing all the radii
% outputs
% ri - a vector containing all the inner radii
% ro - a vector containing all the outer radii

ro = r(1:2:end); % Extract inner radii (odd indices)
ri = r(2:2:end); % Extract outer radii (even indices)