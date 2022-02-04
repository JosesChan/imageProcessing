% Task 5: Robust method --------------------------

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_14.png');

% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);
I_gray = imresize(I_gray,[512, NaN],"bicubic");
figure, imshow(I_gray)

% Step 3: Morpohology
%se = strel('disk',4);
%morph_gray = imclose(I_gray, se);
%morph_gray = imsharpen(morph_gray);
%morph_gray = imfill(morph_gray);
%figure, imshow(morph_gray);

% Filter for noise
%h = fspecial("average");
%morph_gray= imfilter(I_gray,h);
%figure, imshow(morph_gray);

% Step-5: Enhance image before binarisation
%enhanced_I_gray = imadjust(morph_gray);
%figure, imshow(enhanced_I_gray);
%figure, imhist(enhanced_I_gray, 64);

% Contour Method
% convex hull of all images
% 80 due to dark/light pixel value
mask = zeros(size(I_gray));
mask(1:end-1,1:end-1) = 1;
figure, imshow(mask);

segment_I = activecontour(I_gray,mask,500);
figure, imshow(segment_I);


% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
%GT = imread("IMG_01_GT.png");

% To visualise the ground truth image, you can
% use the following code.
%L_GT = label2rgb(GT, 'prism','k','shuffle');
%figure, imshow(L_GT);