% Task 5: Robust method --------------------------

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_11.png');

% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);

% Step 3: Morpohology

% Step-5: Enhance image before binarisation
enhanced_I_gray = imadjust(I_gray);

% Step 6: Fill in gaps

% Create images with padding of a white line
% to fill in boundary bloodcells, 2 edge pads per corner
nw_segmentation_I=padarray(segmentation_I,[1 1],1,"pre");ne_segmentation_I=padarray(segmentation_I,[1 0],1,"pre");
ne_segmentation_I=padarray(ne_segmentation_I,[0 1],1,"post");se_segmentation_I=padarray(segmentation_I,[1 1],1,"post");
sw_segmentation_I=padarray(segmentation_I,[1 0],1,"post");sw_segmentation_I=padarray(sw_segmentation_I,[0 1],1,"pre");

% Image fill on all border pad image to gain border image segments
nw_segmentation_I=imfill(nw_segmentation_I,"holes");ne_segmentation_I=imfill(ne_segmentation_I,"holes");
se_segmentation_I=imfill(se_segmentation_I,"holes");sw_segmentation_I=imfill(sw_segmentation_I,"holes");

% Remove padding from each pad image
nw_segmentation_I=nw_segmentation_I(2:end,2:end);ne_segmentation_I=ne_segmentation_I(2:end,1:end-1);
se_segmentation_I=se_segmentation_I(1:end-1,1:end-1);sw_segmentation_I=sw_segmentation_I(1:end-1,2:end);

% Logical Or operator, allowing pixels from different padding images
% to fill in areas where other images aren't filled
segmentation_I=nw_segmentation_I|ne_segmentation_I|se_segmentation_I|sw_segmentation_I;

% Step-7: Image Binarisation
segmentation_I = imbinarize(enhanced_I_gray);
figure, imshow(segmentation_I);

% Contour Method
% convex hull of all images
mask = I_gray > 80; % 80 due to dark/light pixel value
mask = bwconvhull(mask, 'Union');
figure, imshow(mask);
segment_I = activecontour(segmentation_I,mask, "edge");

figure, imshow(segmented_I)

% Template Matching
% Pearson Correlation

%Read an Image A(Template)
A1 = imread('.jpg');

%Read the Target Image
B1 = imread('.jpg');

A = A1(:,:,1);
B = B1(:,:,1);

corr_map = zeros([size(A,1),size(A,2)]);

for i = 1:size(A,1)-size(B,1)
    for j = 1:size(A,2)-size(B,2)
        %Construct the correlation map
        corr_map(i,j) = corr2(A(i:i+size(B,1)-1,j:j+size(B,2)-1),B);
    end
end

figure,images(corr_map);colorbar;
%Find the maximum value
maxpt = max(corr_map(:));
[x,y]=find(corr_map==maxpt);

%Display the image from the template
figure,imagesc(B1);title('Target Image');colormap(gray);axis image

grayA = rgb2gray(A1);
Res   = A;
Res(:,:,1)=grayA;
Res(:,:,2)=grayA;
Res(:,:,3)=grayA;

Res(x:x+size(B,1)-1,y:y+size(B,2)-1,:)=A1(x:x+size(B,1)-1,y:y+size(B,2)-1,:);

figure,imagesc(Res);


% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
GT = imread("IMG_01_GT.png");

% To visualise the ground truth image, you can
% use the following code.
L_GT = label2rgb(GT, 'prism','k','shuffle');
figure, imshow(L_GT)