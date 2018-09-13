% Written by Henry Hu for CSCI 1430 @ Brown and CS 4495/6476 @ Georgia Tech

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


[sa,~] = size(matches_a);
num_rand_pts = 8;
ransac_iter = 2000;
inlier_threshold = 0.08;

max_inliers = 0;
for x=1:1:ransac_iter
    rand_int_pts = randi(sa, num_rand_pts, 1);
    rand_a = matches_a(rand_int_pts, :);
    rand_b = matches_b(rand_int_pts, :);
    curr_F = estimate_fundamental_matrix(rand_a, rand_b);
    
    num_inliers = 0;
    for y=1:1:sa
        p1 = [matches_a(y,:) 1];
        p2 = [matches_b(y,:) 1];
        corresp = p2*curr_F*p1';
        if abs(corresp) < inlier_threshold
            num_inliers = num_inliers+1;
        end
    end
    
    if num_inliers>max_inliers
        max_inliers = num_inliers
        Best_Fmatrix = curr_F;
        inliers_a = [];
        inliers_b = [];
        for y=1:1:sa
            p1 = [matches_a(y,:) 1];
            p2 = [matches_b(y,:) 1];
            corresp = p2*curr_F*p1';
            if abs(corresp) < inlier_threshold
                inliers_a = [inliers_a; matches_a(y,:)];
                inliers_b = [inliers_b; matches_b(y,:)];
            end
        end
    end
end

% Choose the best F (most inliers) and return the set of inliers
%Best_Fmatrix = best_F; 
%inliers_a = matches_a(best_inlier_indices ,:);
%inliers_b = matches_b(best_inlier_indices, :);
end

