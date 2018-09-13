% Fundamental Matrix Stencil Code
% Written by Henry Hu for CSCI 1430 @ Brown and CS 4495/6476 @ Georgia Tech

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

[n, ~] = size(Points_a);
A = zeros(n, 9);
for i = 1:n
    u_a = Points_b(i, 1);
    v_a = Points_b(i, 2);
    u_b = Points_a(i, 1);
    v_b = Points_a(i, 2);
    A(i, :) = [u_b*u_a v_b*u_a u_a u_b*v_a v_b*v_a v_a u_b v_b 1];
end

[~, ~, V] = svd(A);
F = V(:, end);
F_matrix = reshape(F, [3 3])';

[U, S, V] = svd(F_matrix);
S(3, 3) = 0;
F_matrix = U * S * V';
        
end

