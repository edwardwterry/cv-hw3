function [dp_x,dp_y] = LucasKanade(It, It1, rect)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [dp_x, dp_y] in the x- and y-directions.

rect = uint16(rect); % converting to integers so it doesn't complain
T = It(rect(2):rect(4),rect(1):rect(3)); % create a template based on It. Updates every frame

[x,y,~]=size(It);
[xt,yt,~]=size(T);

p = [0 0]'; % initial guess for p

eps = 1e-3; % convergence threshold
[It1x,It1y] = gradient(It1);

[U,V] = meshgrid(1:y,1:x); % x and y coordinates of rectangle
c=cat(2,U',V');
coords=double([reshape(c,[],2) ones(size(U,1)*size(U,2),1)]);

i = 1;
metric = 1;
metric_difference = 1;

while metric_difference>eps
    
    % warp I with W(x,p) to compute I(W(x,p))
    W = [1 0 p(1); 0 1 p(2)];
    warped_coords = (W*coords')'; %
    Vq = reshape(warped_coords(:,2),[y,x])'; % make into equivalent meshgrids to above
    Uq = reshape(warped_coords(:,1),[y,x])';
    I_w = interp2(It1,Uq,Vq); % warped It1
    I_w_crop = I_w(rect(2):rect(4),rect(1):rect(3));
    
    % compute error image
    bc = T-I_w_crop;
    bc_col = reshape(bc,[xt*yt,1]);
    
    % warp gradient delI with W(x,p)
    delIx_w = interp2(It1x,Uq,Vq);
    delIx_w_crop = delIx_w(rect(2):rect(4),rect(1):rect(3));
    delIy_w = interp2(It1y,Uq,Vq);
    delIy_w_crop = delIy_w(rect(2):rect(4),rect(1):rect(3));
    delIcol_crop = [reshape(delIx_w_crop,[xt*yt,1]) reshape(delIy_w_crop,[xt*yt,1])];
    
    % evaluate Jacobian at (x,p)
    J = [1 0;0 1];
    
    % compute steepest descent images: delI * Jacobian
    A = delIcol_crop*J;
    
    % compute Hessian
    H = A'*A;
    
    % compute delta_p
    delta_p = H\A'*bc_col;
    
    % update the parameters
    i = i+1;
    p = p+delta_p;
    
    past_metric = metric;
    metric = (norm(delta_p))^2;
    metric_difference = abs(metric-past_metric);
end

dp_x = p(1);
dp_y = p(2);
end