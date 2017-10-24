clc
clear
close all

load('../data/aerialseq.mat');
frames = im2double(frames);

It = frames(:,:,1);
It1 = frames(:,:,2);
numFrames = size(frames,3);
mask = zeros(size(frames,1),size(frames,2),size(frames,3));
for i = 2:numFrames
    mask(:,:,i) = SubtractDominantMotion(frames(:,:,i-1),frames(:,:,i));
    i
end
save('mask.mat','mask')
% M = LucasKanadeAffine(It,It1);
% for i = 2:size(frames,3)
%     [M] = LucasKanadeAffine(frames(:,:,i-1), frames(:,:,i), rects(:,i-1));
%     rects(:,i) = [rects(1,i-1)+dp_x,rects(2,i-1)+dp_y,rects(3,i-1)+dp_x,rects(4,i-1)+dp_y]';
% end