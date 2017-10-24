load('sylvseqrects.mat')
load('../data/sylvseq.mat')
rects=rects';
figure
rect = [102, 62, 156, 108]';

for i = 1:size(frames,3)
    imshow(frames(:,:,i));
    hold on
    rectangle('Position',[rects(1,i) rects(2,i) rect(3)-rect(1) rect(4)-rect(2)])
    hold off
    pause(0.001)
end