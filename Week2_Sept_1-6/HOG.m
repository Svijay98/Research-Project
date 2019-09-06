clc;
img = imread('shivu.jpg');
img = rgb2gray(img);
img = imresize(img,[64 128]);
features = extractHOGFeatures(img);
size(features)