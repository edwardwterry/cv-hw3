close all

% Q1
load('carseqrects.mat')
rects_car = rects';

load('carseqrects-wcrt.mat')
rects_car_wcrt = rects';

load('../data/carseq.mat')
Q1video = frames;

Q1_rect = [60,117,146,152]';

% Q2
load('sylvseqrects.mat')
rects_sylv_ab = rects';

load('sylvseqrects_original.mat')
rects_sylv_lk = rectslk;

load('../data/sylvseq.mat')
Q2video = frames;

Q2_rect = [102,62,156,108]';


% Q3

Q1frames = [1 100 200 300 400];
Q2frames = [1 200 300 350 400];
Q3frames = [30 60 90 120];

% plot Q1.3

figure
for i = 1:length(Q1frames)
    subplot(1,length(Q1frames),i)
    imshow(Q1video(:,:,Q1frames(i)))
    hold on
    rectangle('Position',[rects_car(1,Q1frames(i)) rects_car(2,Q1frames(i)) Q1_rect(3)-Q1_rect(1) Q1_rect(4)-Q1_rect(2)],'EdgeColor','g')
    hold off
    title(['Frame ' num2str(Q1frames(i))])
end

% plot Q1.4

figure
for i = 1:length(Q1frames)
    subplot(1,length(Q1frames),i)
    imshow(Q1video(:,:,Q1frames(i)))
    hold on
    rectangle('Position',[rects_car(1,Q1frames(i)) rects_car(2,Q1frames(i)) Q1_rect(3)-Q1_rect(1) Q1_rect(4)-Q1_rect(2)],'EdgeColor','g')
    rectangle('Position',[rects_car_wcrt(1,Q1frames(i)) rects_car_wcrt(2,Q1frames(i)) Q1_rect(3)-Q1_rect(1) Q1_rect(4)-Q1_rect(2)],'EdgeColor','y')
    title(['Frame ' num2str(Q1frames(i))])
    hold off
end

% plot Q2

figure
for i = 1:length(Q2frames)
    subplot(1,length(Q2frames),i)
    imshow(Q2video(:,:,Q2frames(i)))
    hold on
    rectangle('Position',[rects_sylv_ab(1,Q2frames(i)) rects_sylv_ab(2,Q2frames(i)) Q2_rect(3)-Q2_rect(1) Q2_rect(4)-Q2_rect(2)],'EdgeColor','g')
    rectangle('Position',[rects_sylv_lk(1,Q2frames(i)) rects_sylv_lk(2,Q2frames(i)) Q2_rect(3)-Q2_rect(1) Q2_rect(4)-Q2_rect(2)],'EdgeColor','y')
    title(['Frame ' num2str(Q2frames(i))])
    hold off
end

