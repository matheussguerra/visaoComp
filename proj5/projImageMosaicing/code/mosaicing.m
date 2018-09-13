function mosaicedIm = mosaicing(im1, im2, iter)
% MOSIACING stitches two images into one

% INPUT
% im1, im2   = input rgb images, im2 is the source and im1 is the destination
% iter       = iteration number for multiple image stitching

% OUTPUT
% mosaicedIm = stitched color image between original two color images

if nargin < 3
   iter = []; 
end

% Parameters
max_pts       = 400;
threshRANSAC  = 5;
blendFrac     = 0.5;
geometricBlur = false;
verbose       = true;

% Feature matching
[ pts1, pts2 ] = sift_wrapper(im1, im2);
Y1 = pts1(:,2);
X1 = pts1(:,1);
Y2 = pts2(:,2);
X2 = pts2(:,1);

% Estimate homography by RANSAC
[H, ~] = ransac_est_homography(Y1, X1, Y2, X2, threshRANSAC, iter, im1, im2, verbose);

% Handle the bounds for transformed source image
[yDes, xDes, ~]       = size(im1);
[ySrc, xSrc, ~]       = size(im2);
[xBound, yBound]   = apply_homography(H, [1; 1; xSrc; xSrc], [1; ySrc; 1; ySrc]);
minBound           = round(min([xBound, yBound], [], 1));
maxBound           = round(max([xBound, yBound], [], 1));
[xMatrix, yMatrix] = meshgrid(minBound(1) : maxBound(1), minBound(2) : maxBound(2));
xArray             = reshape(xMatrix, [numel(xMatrix), 1]);
yArray             = reshape(yMatrix, [numel(yMatrix), 1]);
[xSrcArr, ySrcArr] = apply_homography(inv(H), xArray, yArray);
xSrcArr            = round(xSrcArr);
ySrcArr            = round(ySrcArr);

% Handle bounds for stitched image
minMosaic   = min([minBound; [1 1]], [], 1);
maxMosaic   = max([maxBound; [xDes, yDes]], [], 1);
rangeMosaic = maxMosaic - minMosaic + 1;
mosaicedIm  = uint8(zeros(rangeMosaic(2), rangeMosaic(1), 3));
minDes      = 1 - (minMosaic ~= 1) .* minMosaic;
mosaicedIm(minDes(2) : (minDes(2) + yDes - 1), minDes(1) : (minDes(1) + xDes - 1), :) = im1;

% Remove non-effective pixels
effectIdx = xSrcArr >= 1 & xSrcArr <= xSrc & ySrcArr >= 1 & ySrcArr <= ySrc;
xArray    = xArray(effectIdx);
yArray    = yArray(effectIdx);
xSrcArr   = xSrcArr(effectIdx);
ySrcArr   = ySrcArr(effectIdx);

% Stitiching the source image with blending
for i = 1 : length(xArray)
    if all(mosaicedIm(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) == 0)
        mosaicedIm(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) = im2(ySrcArr(i), xSrcArr(i), :);
    else
        mosaicedIm(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) = blendFrac * mosaicedIm(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) ...
                                              + (1 - blendFrac) * im2(ySrcArr(i), xSrcArr(i), :);
    end
end
mosaicedIm = im2uint8(mosaicedIm);

end
