%% Get values from figure
% This code prints important values from frame showed in figure
% by clicking on specific point in figure
clc;
clear all;
close all;

bg = imread('bg.jpg');
img = imread('img.jpg');
IMG = img;

delta = 7;

%% Calling GetCoordinatesFromFigure(img, num) function with parameters
% img = source of image to show
% num = number of allowed on-clicks
figure;
POINTS = GetCoordinatesFromFigure(img, 1);
imshow(img);

i = int32(POINTS(1))
j = int32(POINTS(2))

%% Showing red square over on-click zone
IMG(j-delta:j+delta,i-delta:i+delta, 1) = 250;
IMG(j-delta:j+delta,i-delta:i+delta, 2) = 0;
IMG(j-delta:j+delta,i-delta:i+delta, 3) = 0;
imshow(IMG);

%% Printing important values of on-click pixel
mR = int16( img(j-delta:j+delta,i-delta:i+delta, 1));
meanR = median(median(mR))

mG = int16( img(j-delta:j+delta,i-delta:i+delta, 2));
meanG = median(median(mG))

mB = int16( img(j-delta:j+delta,i-delta:i+delta, 3));
meanB = median(median(mB))

bg_mR = int16( bg(j-delta:j+delta,i-delta:i+delta, 1));
bg_meanR = median(median(bg_mR))

bg_mG = int16( bg(j-delta:j+delta,i-delta:i+delta, 2));
bg_meanG = median(median(bg_mG))

bg_mB = int16( bg(j-delta:j+delta,i-delta:i+delta, 3));
bg_meanB = median(median(bg_mB))

diffR = abs(bg_meanR - meanR)
diffG = abs(bg_meanG - meanG)
diffB = abs(bg_meanB - meanB)

maximum = max([meanR meanG meanB]);
minimum = min([meanR meanG meanB]);
rozdiel = abs(maximum - minimum)