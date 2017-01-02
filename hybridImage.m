function  hybridImage(img1 , img2)

img1 = ((img1)); %do rgb to gray conversion if needed
img2 = ((img2)); %do rgb to gray conversion if needed
close all; 
%clear all;

hsize = 8; 
sigma = 5;
pyramidSize = 8;
cutOffFreq1 = 2;

%get Guassian and Laplacian pyramids of image 1
[gussianPyramid1 , laplacianPyramid1] = getPyramids(img1 , hsize , sigma , pyramidSize);

%get Guassian and Laplacian pyramids of image 1
[gussianPyramid2 , laplacianPyramid2] = getPyramids(img2 , hsize , sigma , pyramidSize);



%Allocate hybrid Pyramid of size pyramidSize + 1
hybridPyramid1 =  cell(pyramidSize + 1 , 1);

%high frequecny are selected from pyrmaid 1 low frequcy from pyrmaid 2 
for i =  pyramidSize  : - 1 : 1
    if(i <= cutOffFreq1)
        hybridPyramid1{i , 1}  =  laplacianPyramid1{i , 1} ;
    else
        hybridPyramid1{i , 1}  = laplacianPyramid2{i , 1} ;
    end;
end;

%Guassain blur is stored for lower frequenies
hybridPyramid1{pyramidSize + 1 , 1}  = gussianPyramid2{pyramidSize , 1} ;

for i = pyramidSize + 1:  -1 : 2
    h1 = cell2mat(hybridPyramid1(i , 1));
    temp = cell2mat(hybridPyramid1(i - 1  , 1));

    sz = size(temp);
    h1 = imresize(h1 , sz(1:2));

    temp = temp + h1;
    figure;
 
    imshow(temp);
   
    hybridPyramid1{i - 1  , 1} = temp;
end;

hybrid = cell2mat(hybridPyramid1(1   , 1));
figure;
imshow(hybrid);
title('Hybrid Image');
end

%Utility method to return Gussian and Laplacian Pyramids
function [gussianPyramid , laplacianPyramid] = getPyramids(img , hsize , sigma , pyramidSize)
    gussianPyramid = cell(pyramidSize, 1);
    gussFilter = fspecial('gaussian', hsize , sigma );
    for i = 1 : pyramidSize
        g1 = imfilter(img , gussFilter,'symmetric');
        gussianPyramid{i , 1} = g1;
        laplacianPyramid{i , 1} = img - g1;
        img = imresize(g1 , .5);%g1(1:2:end  , 1:2:end , :);
    end;
end

