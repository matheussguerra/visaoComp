function [hybrid_image,low_frequencies,high_frequencies] = gen_hybrid_image_fft( image1, image2, cutoff_frequency )
% Inputs:
% - image1 -> The image from which to take the low frequencies.
% - image2 -> The image from which to take the high frequencies.
% - cutoff_frequency -> The standard deviation, in pixels, of the Gaussian 
%                       blur that will remove high frequencies.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the high frequencies from image1 by blurring it. The amount of
% blur that works best will vary with different image pairs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
low_frequencies = [];

figure, imshow(image1);
b = padarray(image1, size(image1), "zeros", "post");
c = im2double(b(:,:,1:3));
d = fft2(c);
d = fftshift(d);
figure, imshow(uint8(abs(d)));

[n m o] = size(c);
h = zeros([n,m]);
for i = 1:n
for j = 1:m
h(i,j) = H(i,j,size(c),cutoff_frequency);
end
end

figure, imshow(im2uint8(h));

g = d.*h;

g = ifftshift(g);
at = ifft2(g);
[x y o] = size(image1);
atc = at(1:x,1:y, :);

figure, imshow(low_frequencies = atc);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the low frequencies from image2. The easiest way to do this is to
% subtract a blurred version of image2 from the original version of image2.
% This will give you an image centered at zero with negative values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
high_frequencies = [];

figure, imshow(image2);
b = padarray(image2, size(image2), "zeros", "post");
c = im2double(b(:,:,1:3));
d = fft2(c);
d = fftshift(d);
figure, imshow(uint8(abs(d)));

[n m o] = size(c);
h = zeros([n,m]);
for i = 1:n
for j = 1:m
h(i,j) = H(i,j,size(c),cutoff_frequency);
end
end

h = imcomplement(h);
figure, imshow(im2uint8(h));

g = d.*h;

g = ifftshift(g);
at = ifft2(g);
[x y o] = size(image2);
atc = at(1:x,1:y, :);

figure, imshow(high_frequencies = atc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine the high frequencies and low frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hybrid_image = [];

hybrid_image = abs(low_frequencies + high_frequencies);

