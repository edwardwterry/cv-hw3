clc
clear
close all

load('../data/carseq.mat');
frames = im2double(frames);
It = frames(:,:,1);
It1 = frames(:,:,2);
rect = [60,117,146,152]';
rect_history(:,1) = rect;
h = waitbar(0,'Please wait...');
steps = size(frames,3);
% for i = 2:size(frames,3)
%     [dp_x,dp_y] = LucasKanade(frames(:,:,i-1), frames(:,:,i), rect_history(:,i-1));
%     rect_history(:,i) = [rect_history(1,i-1)+dp_x,rect_history(2,i-1)+dp_y,rect_history(3,i-1)+dp_x,rect_history(4,i-1)+dp_y]';
%     waitbar(i / steps)
% end
for i = 2:15%%size(frames,3)
    [dp_x,dp_y] = LucasKanade(It, It1, rect);
    rect_history(:,i) = [rect_history(1,i-1)+dp_x,rect_history(2,i-1)+dp_y,rect_history(3,i-1)+dp_x,rect_history(4,i-1)+dp_y]';            
end

for i = 1:415%%size(frames,3)
imshow(frames(:,:,i));
hold on
% rectangle('Position',[rect_history(1,i) rect_history(2,i) rect(3)-rect(1) rect(4)-rect(2)])
hold off
pause(0.01)
end
% hold on
% imshow(It)
% rectangle('Position',[rect(1) rect(2) rect(3)-rect(1) rect(4)-rect(2)])
% figure 
% imshow(It1)
% rectangle('Position',[rect(1)+dp_x rect(2)+dp_y rect(3)-rect(1) rect(4)-rect(2)])
