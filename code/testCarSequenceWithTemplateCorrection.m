clc
clear
close all

load('../data/carseq.mat');
frames = im2double(frames);

rect = [60,117,146,152]';
rects_wcrt(:,1) = rect;
h = waitbar(0,'Calculating...');
steps = size(frames,3);
for i = 2:steps
    [dp_x,dp_y] = LucasKanadeTemplateCorrection(frames(:,:,i-1), frames(:,:,i), rects_wcrt(:,i-1), frames(:,:,1),rect);
    rects_wcrt(:,i) = [rects_wcrt(1,i-1)+dp_x,rects_wcrt(2,i-1)+dp_y,rects_wcrt(3,i-1)+dp_x,rects_wcrt(4,i-1)+dp_y]';
    waitbar(i/steps);
end

close(h)

load('carseqrects.mat')
rects = rects';

for i = 1:size(frames,3)
    imshow(frames(:,:,i));
    hold on
    rectangle('Position',[rects_wcrt(1,i) rects_wcrt(2,i) rect(3)-rect(1) rect(4)-rect(2)],'EdgeColor','y')
    rectangle('Position',[rects(1,i) rects(2,i) rect(3)-rect(1) rect(4)-rect(2)],'EdgeColor','g')
    hold off
    pause(0.001)
end

rects=rects_wcrt';

save('carseqrects-wcrt.mat','rects')