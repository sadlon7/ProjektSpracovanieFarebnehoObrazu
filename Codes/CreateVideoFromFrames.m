%% Create video file from frames
% This code generates video file from separated image frames
clc;
clear all;
close all;

%% Video initialisation
video = VideoWriter('RemovedShadow');           % Name of video file
video.Quality = 100;                            % Video quality sttings
video.FrameRate = 15;                           % Framerate settings
open(video);
% filepath = ('C:\MATLAB\diplomovka\OpticalFlowFrames\');    % Path

%% Video creation
for k=1:250 
    frame = imread(['OpticalFlowFrames/OF_frame'  ,int2str(k), '.jpg']);   % Path loading
    frameDouble = im2double(frame);                             % Convert to double
    figure()
    imshow(frameDouble)                                         % Showing figure
    writeVideo(video, getframe(gca));                           % Write into video file
    close all; 
%     frame = imread(['ShadowRemovedFrames/RS_frame'  ,int2str(k), '.jpg']);   % Path loading
%     frameDouble = im2double(frame);                             % Convert to double
%     writeVideo(video, frameDouble);                           % Write into video file
end

close(video);
