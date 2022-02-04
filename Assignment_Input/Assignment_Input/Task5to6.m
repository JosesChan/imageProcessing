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
segment_I = bwareaopen(segment_I, 150);
figure, imshow(segment_I);

% Find bloodcells within the image, by looking at 
[centers, radii] = imfindcircles(segment_I, [50 1000], "Sensitivity", 0.95, "method", "TwoStage");
%h = viscircles(centers, radii,'Color','r');
%maskBloodCell = [centers, radii];

[x y]=meshgrid(1:size(I_gray,2),1:size(I_gray,1));
mask=zeros(size(I_gray));

for i=1:numel(radii)
    mask = mask | (x-centers(i,1)).^2+(y-centers(i,2)).^2<=radii(i).^2;
end

bloodcell = segment_I.*mask;
% Label for 
addLabel(ldc,0,labelType);
% Label for blood cells
addLabel(ldc,1,labelType.Rectangle);
% Label for bacteria
addLabel(ldc,2,labelType);
%labelBloodCell = bwlabel(bloodcell);
%imageLabel = (label ==1);

%label bloodcell

figure, imshow(segment_I.*mask);



% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
GT = imread("IMG_01_GT.png");

% To visualise the ground truth image, you can
% use the following code.
L_GT = label2rgb(GT, 'prism','k','shuffle');
figure, imshow(L_GT);