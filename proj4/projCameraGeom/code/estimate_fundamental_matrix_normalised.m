% Normalised Fundamental Matrix Wrapper Code
% Written by Frank Borsato

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix
% 'e1 and e2' are the epipoles

function [ F_matrix, e1, e2 ] = estimate_fundamental_matrix_normalised(Points_a,Points_b)

[F_matrix, e1, e2] = fundmatrix(Points_a,Points_b);
        
end

