%% Multi frame shadow remover
% This code removes shadow of person on video
% clc;
% clear all;
% close all;

%% Initialization
mkdir ShadowRemovedFrames; 

for k = 1:250 
    k
    
    background = imread('bg.jpg');
    img = imread(['Frames/frame'  ,int2str(k), '.jpg']);
    frame = img;
    imageSize = size(img);
    imageSizeX = imageSize(2);
    imageSizeY = imageSize(1);
    mask = uint8(zeros(imageSizeX,imageSizeY));

    delta = 7;

    %% Calculating mask and its median
    % Size of mask is delta*delta
%     for y = 1+delta : imageSize(1)-delta
    for y = 350 : 600

%         if mod(y,80) == 0
%             progress = y*0.125
%         end

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
    structuralElement = strel('disk', 5);
    mask = imopen(mask, structuralElement);

    structuralElement = strel('disk', 11);
    mask = imdilate(mask, structuralElement);

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

    finalFrame = uint8(finalFrame);   
    imwrite(finalFrame, ['ShadowRemovedFrames/RS_frame'  ,int2str(k), '.jpg']);
    
end