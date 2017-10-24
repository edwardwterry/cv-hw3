load('sylvseqrects.mat')
load('sylvseqrects_original.mat')
load('../data/sylvseq.mat')
rectsab=rects';
figure
rect = [102, 62, 156, 108]';

for i = 1:size(frames,3)
    imshow(frames(:,:,i));
    hold on
    rectangle('Position',[rectsab(1,i) rectsab(2,i) rect(3)-rect(1) rect(4)-rect(2)],'EdgeColor','y')
    rectangle('Position',[rectslk(1,i) rectslk(2,i) rect(3)-rect(1) rect(4)-rect(2)],'EdgeColor','g')
    hold off
    pause(0.001)
end