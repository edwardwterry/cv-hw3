close all
load('mask.mat')

testFrame = mask(:,:,45);
testImage = imerode(testFrame,strel('disk',1));
[i,j]=ind2sub([240 320],testImage>0);
testImage2 = bwselect(testImage,j,i,4);
figure
imshow(testImage2);