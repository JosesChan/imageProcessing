clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_01.png');
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
figure, imhist(resized_I_gray, 64)

% Step-5: Enhance image before binarisation
imageIntensity = 255*im2double(resized_I_gray); % converts the intensity image I to double precision
minimum = min(min(imageIntensity)); % find the minimum pixel intensity
maximum = max(max(imageIntensity)); % find the maximum pixel intensity

% Can use imadjust (Visual purposes)
% histeq (Less sensitive to noise) 
% adapthisteq (Enhances noise but highlights contrast for subtle features)

A_enhanced_resized_I_gray = imadjust(resized_I_gray,[minimum/255; maximum/255],[0; 1]);
B_enhanced_resized_I_gray = histeq(resized_I_gray);
C_enhanced_resized_I_gray = adapthisteq(resized_I_gray);

%figure, imshow(A_enhanced_resized_I_gray)
%figure, imshow(B_enhanced_resized_I_gray)
%figure, imshow(C_enhanced_resized_I_gray)

% Step-6: Histogram after enhancement

%figure, imhist(A_enhanced_resized_I_gray, 64)
%figure, imhist(B_enhanced_resized_I_gray, 64)
%figure, imhist(C_enhanced_resized_I_gray, 64)


% Step-7: Image Binarisation
A_binary_I = imbinarize(A_enhanced_resized_I_gray);
B_binary_I = imbinarize(B_enhanced_resized_I_gray);
C_binary_I = imbinarize(C_enhanced_resized_I_gray);

%figure, imshow(A_binary_I)
figure, imshow(B_binary_I)
%figure, imshow(C_binary_I)

% Task 2: Edge detection ------------------------
chosen_I = B_binary_I;

edgeP = edge(chosen_I, "Prewitt");
edgeS = edge(chosen_I, "Sobel");
edgeC = edge(chosen_I, "Canny");
edgeL = edge(chosen_I, "log");


figure, imshow(edgeP)
figure, imshow(edgeS)
figure, imshow(edgeC)
figure, imshow(edgeL)

% Task 3: Simple segmentation --------------------

% Implement morphology techniques

thresh = 0.4;
segmentation_I = imbinarize(A_enhanced_resized_I_gray, 0.2);
figure, imshow(segmentation_I)

% Task 4: Object Recognition --------------------