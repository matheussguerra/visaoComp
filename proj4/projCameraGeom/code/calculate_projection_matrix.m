% Projection Matrix Stencil Code
% Written by Henry Hu, Grady Williams, and James Hays for CSCI 1430 @ Brown and CS 4495/6476 @ Georgia Tech

% Returns the projection matrix for a given set of corresponding 2D and
% 3D points. 

% 'Points_2D' is nx2 matrix of 2D coordinate of points on the image
% 'Points_3D' is nx3 matrix of 3D coordinate of points in the world

% 'M' is the 3x4 projection matrix


function M = calculate_projection_matrix( Points_2D, Points_3D )

% To solve for the projection matrix. You need to set up a system of
% equations using the corresponding 2D and 3D points:

%                                                     [M11       [ u1
%                                                      M12         v1
%                                                      M13         .
%                                                      M14         .
%[ X1 Y1 Z1 1 0  0  0  0 -u1*X1 -u1*Y1 -u1*Z1          M21         .
%  0  0  0  0 X1 Y1 Z1 1 -v1*X1 -v1*Y1 -v1*Z1          M22         .
%  .  .  .  . .  .  .  .    .     .      .          *  M23   =     .
%  Xn Yn Zn 1 0  0  0  0 -un*Xn -un*Yn -un*Zn          M24         .
%  0  0  0  0 Xn Yn Zn 1 -vn*Xn -vn*Yn -vn*Zn ]        M31         .
%                                                      M32         un
%                                                      M33         vn ]

% Then you can solve this using least squares with the '\' operator.
% Notice you obtain 2 equations for each corresponding 2D and 3D point
% pair. To solve this, you need at least 6 point pairs. Note that we set
% M34 = 1 in this scenario. If you instead choose to use SVD, you should
% not make this assumption and set up your matrices by following the 
% set of equations on the project page. 

[rows, ~] = size(Points_2D);
A = zeros(2 * rows, 12);

for i = 1:rows
    u = Points_2D(i, 1);
    v = Points_2D(i, 2);
    x = Points_3D(i, 1);
    y = Points_3D(i, 2);
    z = Points_3D(i, 3);
    row1 = [x y z 1 0 0 0 0 -u*x -u*y -u*z -u];
    row2 = [0 0 0 0 x y z 1 -v*x -v*y -v*z -v];
    A(2 * i - 1, :) = row1;
    A(2 * i, :) = row2;
end

[~, ~, V] = svd(A);
M = V(:, end);
M = reshape(M, [], 3)';


end

