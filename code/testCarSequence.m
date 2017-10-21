clc
clear
close all

load('../data/carseq.mat');
frames = im2double(frames);

rect = [60,117,146,152]';
rects(:,1) = rect;

for i = 2:size(frames,3)
    [dp_x,dp_y] = LucasKanade(frames(:,:,i-1), frames(:,:,i), rects(:,i-1));
    rects(:,i) = [rects(1,i-1)+dp_x,rects(2,i-1)+dp_y,rects(3,i-1)+dp_x,rects(4,i-1)+dp_y]';
end

for i = 1:size(frames,3)
    imshow(frames(:,:,i));
    hold on
    rectangle('Position',[rects(1,i) rects(2,i) rect(3)-rect(1) rect(4)-rect(2)])
    hold off
    pause(0.001)
end

rects=rects';

save('carseqrects.mat','rects')