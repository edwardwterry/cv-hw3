% load('mask.mat')
% moving = ceil((mask>0.2).*mask); % pick up on pixels which are seen to be moving
% if moving>0
%    moving 
% end



figure
for i = 1:144
    imshow(mask(:,:,i));
    pause(0.01)
end
