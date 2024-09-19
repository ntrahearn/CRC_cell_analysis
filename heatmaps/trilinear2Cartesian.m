function CartCoords = trilinear2Cartesian(TriCoords, RefTriangle)
%TRILINEAR2CARTESIAN Summary of this function goes here
%   Detailed explanation goes here
    v1 = RefTriangle(2, :) - RefTriangle(1, :);
    v2 = RefTriangle(3, :) - RefTriangle(1, :);
    v3 = RefTriangle(3, :) - RefTriangle(2, :);
    
    l1 = sqrt(sum(v1.^2));
    l2 = sqrt(sum(v2.^2));
    l3 = sqrt(sum(v3.^2));
    
    k = 1./sum([l3 l2 l1].*TriCoords, 2);
    
    n = k.*TriCoords(:, 3).*l1;
    m = k.*TriCoords(:, 2).*l2;
    
    CartCoords = v1.*m + v2.*n + RefTriangle(1, :);
end