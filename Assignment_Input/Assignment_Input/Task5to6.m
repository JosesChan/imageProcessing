% Task 5: Robust method --------------------------

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_11.png');

% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);
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
segment_I = bwareaopen(segment_I, 150);

% Find bloodcells within the image, by looking at 
[centers, radii] = imfindcircles(segment_I, [50 1000], "Sensitivity", 0.95, "method", "TwoStage");

% Create mask
[x, y]=meshgrid(1:size(I_gray,2),1:size(I_gray,1));
mask=zeros(size(I_gray));

for i=1:numel(radii)
    mask = mask | (x-centers(i,1)).^2+(y-centers(i,2)).^2<=radii(i).^2;
end

bloodcell = segment_I.*mask;
figure, imshow(segment_I.*mask);

% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
GT = imread("IMG_11_GT.png");

bloodcell = imbinarize(bloodcell);
bacteria = xor(segment_I, bloodcell);
background = zeros(size(I_gray));

figure, imshow(bloodcell);
figure, imshow(bacteria);
figure, imshow(background);

similarity = dice(bloodcell, imbinarize(GT));

figure
imshowpair(bloodcell, imbinarize(GT));
title(['Dice Index = ' num2str(similarity)]);

%[precision] = bfscore(bloodcell,GT(1));
%[recall] = bfscore(bloodcell,GT(1));

%imshowpair(bloodcell, GT(1))
%title(['Precision Index = ' num2str(precision)]);

%imshowpair(bloodcell, GT(1))
%title(['Recall Index = ' num2str(recall)]);
