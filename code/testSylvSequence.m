clc
close all
clear

load('../data/sylvbases.mat')
load('../data/sylvseq.mat')

frames = im2double(frames);

It = frames(:,:,1);
It1 = frames(:,:,2);

rect = [102, 62, 156, 108]';
[dp_x,dp_y] = LucasKanadeBasis(It, It1, rect, bases);
rects(:,1) = rect;

h = waitbar(0,'message')

for i = 2:size(frames,3)
    [dp_x,dp_y] = LucasKanadeBasis(frames(:,:,i-1), frames(:,:,i), rects(:,i-1),bases);
    rects(:,i) = [rects(1,i-1)+dp_x,rects(2,i-1)+dp_y,rects(3,i-1)+dp_x,rects(4,i-1)+dp_y]';
        waitbar(i / size(frames,3))

end