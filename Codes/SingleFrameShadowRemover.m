%% Single frame shadow remover
% This code removes shadow of person on one frame of video
% clc;
% clear all;
% close all;

%% Initialization
background = imread('bg.jpg');
img = imread('img9.jpg');
frame = img;
imageSize = size(img);
imageSizeX = imageSize(2);
imageSizeY = imageSize(1);


delta = 7;

%% Calculating mask and its median
% Size of mask is delta*delta

mask = uint8(zeros(imageSizeX,imageSizeY));
% for y = 1+delta : imageSize(1)-delta
for y = 350 : 600
    
    if mod(y,80) == 0
        progress = y*0.125
    end
    
    for x = 1+delta : imageSize(2)-delta
        
        rangeX = x-delta : x+delta;
        rangeY = y-delta : y+delta;
        
        fameMaskRED = int16(frame(rangeY, rangeX, 1));
        medianOfFameMaskRED = median(median(fameMaskRED));

        fameMaskGREEN = int16(frame(rangeY, rangeX, 2));
        medianOfFameMaskGREEN = median(median(fameMaskGREEN));

        fameMaskBLUE = int16(frame(rangeY, rangeX, 3));
        medianOfFameMaskBLUE = median(median(fameMaskBLUE));

        backgroundMaskRED = int16(background(rangeY, rangeX, 1));
        medianOfBackgroundMaskRED = median(median(backgroundMaskRED));

        backgroundMaskGREEN = int16(background(rangeY, rangeX, 2));
        medianOfBackgroundMaskGREEN = median(median(backgroundMaskGREEN));

        backgroundMaskBLUE = int16(background(rangeY, rangeX, 3));
        medianOfBackgroundMaskBLUE = median(median(backgroundMaskBLUE));

        differenceRED = abs(medianOfBackgroundMaskRED - medianOfFameMaskRED);
        differenceGREEN = abs(medianOfBackgroundMaskGREEN - medianOfFameMaskGREEN);
        differenceBLUE = abs(medianOfBackgroundMaskBLUE - medianOfFameMaskBLUE);
        
        maximum = max([medianOfFameMaskRED medianOfFameMaskGREEN medianOfFameMaskBLUE]);
        minimum = min([medianOfFameMaskRED medianOfFameMaskGREEN medianOfFameMaskBLUE]);
        colorDifference = abs(maximum - minimum);
        
        if (100 < differenceRED) && (differenceRED < 140) && (95 < differenceGREEN) && (differenceGREEN < 130) && (85 < differenceBLUE) && (differenceBLUE < 120) && (colorDifference < 8)
          mask(y,x) = 255;
        end
    end
end

%% Morphological opening and dilatation
% structuralElement = strel('disk', 5);
% mask2 = imopen(mask, structuralElement);

structuralElement = strel('disk', 6);
mask2 = imerode(mask, structuralElement);

% se = zeros(41,41);
% se(20:41,20:41) = 1;
% se = logical(se);
%structuralElement2 = strel('disk', 21);
mask2 = imdilate(mask2, se);


%% Creation of new frame without shadow
finalFrame = zeros(imageSizeX, imageSizeY, 3);

for i = 1:imageSizeY
    for j = 1:imageSizeX
        if mask2(i, j) ~= 0
            finalFrame(i, j, 1) = background(i, j, 1);
            finalFrame(i, j, 2) = background(i, j, 2);
            finalFrame(i, j, 3) = background(i, j, 3);
        else
            finalFrame(i, j, 1) = frame(i, j, 1);
            finalFrame(i, j, 2) = frame(i, j, 2);
            finalFrame(i, j, 3) = frame(i, j, 3);
        end
    end
end

%% Showing figure with result
finalFrame = uint8(finalFrame);

figure;
subplot(2,3,1); imshow(background);     title('Pozadie videa');
subplot(2,3,2); imshow(frame);          title('Frame videa');
subplot(2,3,3); imshow(mask);           title('Detekcia pohybujucich sa tieov');
subplot(2,3,4); imshow(mask2);          title('Morfologia (otvorenie + dilatacia)');
subplot(2,3,5); imshow(finalFrame);     title('Odstraneny tien');