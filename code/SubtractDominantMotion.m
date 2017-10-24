function mask = SubtractDominantMotion(image1, image2)

% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size

movingThreshold = 0.6;

M = LucasKanadeAffine(image1, image2);
tform = affine2d(M');
im1warped = imwarp(image1,tform);
if size(im1warped,1)<240% 320];
    missingRow = im1warped(size(im1warped,1),:);
    im1warped = [im1warped;missingRow];
end
if size(im1warped,2)<320% 320];
    missingCol = im1warped(:,size(im1warped,2));
    im1warped = [im1warped missingCol];
end
diff = abs(image2-im1warped(1:240,1:320));
mask = ceil((diff>movingThreshold).*diff); % pick up on pixels which are seen to be moving
end