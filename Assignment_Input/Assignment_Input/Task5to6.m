% Task 5: Robust method --------------------------

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_11.png');

% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);
I_gray = imresize(I_gray,[512, NaN],"bicubic");
figure, imshow(I_gray)

% Step 3: Morpohology
SE = strel('disk',4);
I_gray = imsharpen(I_gray);
%I_gray = imfill(I_gray,"holes");
I_gray = imopen(I_gray, SE);
figure, imshow(I_gray);

% Step 3: Morpohology
%se = strel('disk',4);
%morph_gray = imclose(I_gray, se);
%morph_gray = imsharpen(morph_gray);
%morph_gray = imfill(morph_gray);
%figure, imshow(morph_gray);

% Contour Method
% Create mask from image size, difference of 1 row and 1 col
mask = zeros(size(I_gray));
mask(1:end-1,1:end-1) = 1;
figure, imshow(mask);

% Apply active contour alg
segment_I = activecontour(I_gray,mask,500);
% Remove small blobs
segment_I = bwareaopen(segment_I, 100)
figure, imshow(segment_I);



% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
%GT = imread("IMG_01_GT.png");

% To visualise the ground truth image, you can
% use the following code.
%L_GT = label2rgb(GT, 'prism','k','shuffle');
%figure, imshow(L_GT);