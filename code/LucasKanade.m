function [dp_x,dp_y] = LucasKanade(It, It1, rect)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [dp_x, dp_y] in the x- and y-directions.
rect = uint16(rect); % converting to integers so it doesn't complain
T = It(rect(2):rect(4),rect(1):rect(3)); % create a template based on It
% Ic = It1(rect(2):rect(4),rect(1):rect(3)); % create a template based on It1, Ic for I cropped
[x,y,~]=size(It);
[xt,yt,~]=size(T);
p = [0 0]'; % initial guess for p
delta_p = [0 0]'; % initial guess for p

eps = 1e-3; % convergence threshold
[It1x,It1y] = gradient(It1);
% delIcol = [reshape(It1x,[x*y,1]) reshape(It1y,[x*y,1])];
% p_star = 1; % to allow it to enter the loop
% fineRes = 10;

% create a matrix with num rows = num pixels
% each row is a unique combination of x,y coords for each pixel
% 3rd column is 1, to make it homogenous

% It_vect = reshape(It,[x*y,1]); % reshaping image into a single column vector
% It_return = reshape(It_vect,[x,y]); % reshaping back to an image
% arrange rectangle segments of each image into vector form
% [V,U] = meshgrid(1:y,1:x);

% [B,A] = meshgrid(rect(2):rect(4),rect(1):rect(3)); % x and y coordinates of rectangle
% % [Af,Bf] = meshgrid(rect(2):1/fineRes:rect(4),rect(1):1/fineRes:rect(3));
% c=cat(2,A',B');
% coords=double([reshape(c,[],2) ones(size(A,1)*size(A,2),1)]);
[V,U] = meshgrid(1:y,1:x); % x and y coordinates of rectangle
% [Af,Bf] = meshgrid(rect(2):1/fineRes:rect(4),rect(1):1/fineRes:rect(3));
c=cat(2,U',V');
coords=double([reshape(c,[],2) ones(size(U,1)*size(U,2),1)]);
% 
% [Bt,At] = meshgrid(1:yt,1:xt); % x and y coordinates of rectangle
% % [Af,Bf] = meshgrid(rect(2):1/fineRes:rect(4),rect(1):1/fineRes:rect(3));
% ct=cat(2,At',Bt');
% coords_t=double([reshape(ct,[],2) ones(size(At,1)*size(At,2),1)]);
i = 2;
metric = 1;
metric_error = 1;
while metric_error>eps%% && i<50
    past_metric = metric;
    % warp I with W(x,p) to compute I(W(x,p))
    W = [1 0 delta_p(1); 0 1 delta_p(2)];
%     warped_coords_t = (W*coords_t')'; % 
%     Uq = reshape(warped_coords_t(:,2),[yt,xt])';
%     Vq = reshape(warped_coords_t(:,1),[yt,xt])';
%     I_w = interp2(It1,Uq,Vq);
    warped_coords = (W*coords')'; % 
    Uq = reshape(warped_coords(:,2),[y,x])';
    Vq = reshape(warped_coords(:,1),[y,x])';
    I_w = interp2(It1,Uq,Vq); % warped It1
    I_w_crop = I_w(rect(2):rect(4),rect(1):rect(3));
%     I_w = interp2(U,V,It1,15.1,30.1)
%     I_w = interp2(U,V,It1,Uq,Vq)
%     reshaped = reshape(warped_coords,[x,y]);
%     It1w = Iwarped(rect(2):rect(4),rect(1):rect(3)); % extracting same rectangle as for template
%     warped_It1 = interp2(U,V,It,warped_coords(:,1),warped_coords(:,2));

    % compute error image
    b = It-I_w;
    bc = T-I_w_crop;
    bc_col = reshape(bc,[xt*yt,1]);
    
    % warp gradient delI with W(x,p)
    
    delIx_w = interp2(It1x,Uq,Vq);
    delIx_w_crop = delIx_w(rect(2):rect(4),rect(1):rect(3));
    delIy_w = interp2(It1y,Uq,Vq);
    delIy_w_crop = delIy_w(rect(2):rect(4),rect(1):rect(3));
    delIcol = [reshape(delIx_w,[x*y,1]) reshape(delIy_w,[x*y,1])];
    delIcol_crop = [reshape(delIx_w_crop,[xt*yt,1]) reshape(delIy_w_crop,[xt*yt,1])];
    
    % evaluate Jacobian at (x,p)
    J = [1 0;0 1];
    
    % compute steepest descent images delI * Jacobian
    A = delIcol_crop*J;    
    
    % compute Hessian
    H = A'*A;
    % compute delta_p
    delta_p = H\A'*bc_col;
    metric = (norm(delta_p))^2;
    metric_error = abs(metric-past_metric);
%     store(:,i) = delta_p;
    % update the parameters
%     p_star = (norm(A*delta_p-bc_col))^2;
    i = i+1;
    p = p+delta_p;
    
    
end
dp_x = delta_p(1);
dp_y = delta_p(2);
end