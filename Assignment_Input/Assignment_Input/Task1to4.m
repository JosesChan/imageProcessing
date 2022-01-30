clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_11.png');
%figure, imshow(I)

% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);
%figure, imshow(I_gray)

% Step-3: Rescale image
%Reduce the image size to be of height 512 but retain aspect ratio
resized_I_gray =  I_gray;
width=size(I_gray,1);
height=size(I_gray,2);
aspectRatio=height/width;

% Set target height for rescalement and calculate the value for scaling
aimedHeight = 512;
scaleHeight = aimedHeight/height;

% Used bicubic interpolation to retain aspect ratio
resized_I_gray = imresize(resized_I_gray,[512, NaN],"bicubic");

width=size(resized_I_gray,1);
height=size(resized_I_gray,2);
newAspectRatio=height/width;

%figure, imshow(resized_I_gray)

% Step-4: Produce histogram before enhancing, bin size 64
%figure, imhist(resized_I_gray, 64)

% Step-5: Enhance image before binarisation
imageIntensity = 255*im2double(resized_I_gray); % converts the intensity image I to double precision
minimum = min(min(imageIntensity)); % find the minimum pixel intensity
maximum = max(max(imageIntensity)); % find the maximum pixel intensity

% Can use imadjust (Visual purposes) (Not detecting subtle features)
% histeq (Less sensitive to noise) (Too much saturation)
% adapthisteq (Enhances noise but highlights contrast for subtle features)

A_enhanced_resized_I_gray = imadjust(resized_I_gray,[minimum/255; maximum/255],[0; 1]);
B_enhanced_resized_I_gray = histeq(resized_I_gray);
C_enhanced_resized_I_gray = adapthisteq(resized_I_gray);

%figure, imshow(A_enhanced_resized_I_gray)
%figure, imshow(B_enhanced_resized_I_gray)
figure, imshow(C_enhanced_resized_I_gray)

% Step-6: Histogram after enhancement

%figure, imhist(A_enhanced_resized_I_gray, 64)
%figure, imhist(B_enhanced_resized_I_gray, 64)
%figure, imhist(C_enhanced_resized_I_gray, 64)


% Step-7: Image Binarisation
A_binary_I = imbinarize(A_enhanced_resized_I_gray);
B_binary_I = imbinarize(B_enhanced_resized_I_gray);
C_binary_I = imbinarize(C_enhanced_resized_I_gray);

%figure, imshow(A_binary_I)
%figure, imshow(B_binary_I)
%figure, imshow(C_binary_I)

% Task 2: Edge detection ------------------------
chosen_I = C_binary_I;

edgeP = edge(chosen_I, "Prewitt");
edgeS = edge(chosen_I, "Sobel");
edgeC = edge(chosen_I, "Canny");
edgeL = edge(chosen_I, "log");

%figure, imshow(edgeP)
%figure, imshow(edgeS)
%figure, imshow(edgeC)
figure, imshow(edgeL)

% Task 3: Simple segmentation --------------------
% Select image
segmentation_I = A_binary_I;

% Filter for noise
h = fspecial("average",3);
segmentation_I = imfilter(segmentation_I,h);

% Create images with padding of a white line
% to fill in boundary bloodcells, 2 edge pads per corner
nw_segmentation_I=padarray(segmentation_I,[1 1],1,"pre");
ne_segmentation_I=padarray(segmentation_I,[1 0],1,"pre");
ne_segmentation_I=padarray(ne_segmentation_I,[0 1],1,"post");
se_segmentation_I=padarray(segmentation_I,[1 1],1,"post");
sw_segmentation_I=padarray(segmentation_I,[1 0],1,"post");
sw_segmentation_I=padarray(sw_segmentation_I,[0 1],1,"pre");


% Image fill on all border pad image to gain border image segments
nw_segmentation_I=imfill(nw_segmentation_I,"holes");
ne_segmentation_I=imfill(ne_segmentation_I,"holes");
se_segmentation_I=imfill(se_segmentation_I,"holes");
sw_segmentation_I=imfill(sw_segmentation_I,"holes");

% Remove padding from each pad image
nw_segmentation_I=nw_segmentation_I(2:end,2:end);
ne_segmentation_I=ne_segmentation_I(2:end,1:end-1);
se_segmentation_I=se_segmentation_I(1:end-1,1:end-1);
sw_segmentation_I=sw_segmentation_I(1:end-1,2:end);


% Logical Or operator, allowing pixels from different padding images
% to fill in areas where other images aren't filled
segmentation_I=nw_segmentation_I|ne_segmentation_I|se_segmentation_I|sw_segmentation_I;

% Remove small objects with less than 100 pixels
segmentation_I=bwareaopen(segmentation_I,100);

figure, imshow(segmentation_I)


% Task 4: Object Recognition --------------------


