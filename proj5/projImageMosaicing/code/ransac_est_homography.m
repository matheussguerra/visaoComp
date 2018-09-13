function [H, inlier_ind] = ransac_est_homography(y1, x1, y2, x2, thresh, iter, im1, im2, verbose)
% RANSAC_EST_HOMOGRAPHY estimates the homography between two corresponding
% feature points through RANSAC. im2 is the source and im1 is the destination.

% INPUT
% y1,x1,y2,x2 = corresponding point coordinate vectors Nx1
% thresh      = threshold on distance to see if transformed points agree
% iter        = iteration number for multiple image stitching
% im1, im2    = images

% OUTPUT
% H           = the 3x3 matrix computed in final step of RANSAC
% inlier_ind  = nx1 vector with indices of points that were inliers

% Written by Qiong Wang at University of Pennsylvania
% Nov. 9th, 2013


% Initialize
i = 1000;
% original feature matches
N = size(y1, 1);
%cria variavel para gerar pontos aleatorios

best = 0;
for i=1 : i
  %obtem 4 pontos aletorios
  r = randsample(N, 4);
  %estima uma homografia passando os pontos aleatorios
  Homo = est_homography(x1(r), y1(r), x2(r), y2(r));
  %aplica a homografia e armazena o resultado
  [X2homo,Y2homo] = apply_homography(Homo, x2, y2);
  %calcula a diferença das distancias ao quadrado, se for menor que o tresh, armazena no vetor inliers
  inliers = ((x1 - X2homo).^2 + (y1 - Y2homo).^2) <= thresh;
  %calcula a soma de quantidade de matches no inlier
  qtdMatches = sum(inliers);
  %se a qtd de matches > a melhor quantidade de matches
  if (qtdMatches > best)
    %best recebe a quantidade de matches
    best = qtdMatches;
    %bestInlier recebe o inlier que possui a maior quantidade de matches
    bestInlier = inliers;  
  endif
endfor

% melhor inlier apos as iteraçoes
inlier_ind = bestInlier;

H = est_homography(x1(bestInlier),y1(bestInlier),x2(bestInlier),y2(bestInlier));

%% PLACEHOLDER CODE TO PLOT ONLY THE INLIERS WHEN YOU WERE DONE
%inlier_ind = 1:min(size(y1,1),size(y2,1));
%H = est_homography(x1,y1,x2,y2);
%% DELETE THE ABOVE LINES WHEN YOU WERE DONE

% Plot the verbose details
if ~verbose
    return
end

dh1 = max(size(im2,1)-size(im1,1),0);
dh2 = max(size(im1,1)-size(im2,1),0);

h = figure(1)

% Original Matches
subplot(2,1,1);
imshow([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]);
delta = size(im1,2);
line([x1'; x2' + delta], [y1'; y2']);
title(sprintf('%d Original matches', N));
axis image off;

% Inlier Matches
subplot(2,1,2);
imshow([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]);
delta = size(im1,2);
line([x1(inlier_ind)'; x2(inlier_ind)' + delta], [y1(inlier_ind)'; y2(inlier_ind)']);
title(sprintf('%d (%.2f%%) inliner matches out of %d', size(inlier_ind,1), 100*size(inlier_ind,1)/N, N));
axis image off;
drawnow;

% Save the figures
p         = mfilename('fullpath');
rootDir = fileparts(fileparts(p));
outputDir = fullfile(rootDir, 'results/');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
fileString = fullfile(outputDir, ['matches', num2str(iter,'%02d')]);
fig_save(h, fileString, 'png');
end
close(h);
