% Camera Center Stencil Code
% Written by Henry Hu, Grady Williams, and James Hays for CSCI 1430 @ Brown and CS 4495/6476 @ Georgia Tech

% Returns the camera center matrix for a given projection matrix

% 'M' is the 3x4 projection matrix
% 'Center' is the 1x3 matrix of camera center location in world coordinates

function [ Center ] = compute_camera_center( M )

Q = M(:,1:3);
m_4 = M(:,4);
Center = -inv(Q) * m_4;

end

