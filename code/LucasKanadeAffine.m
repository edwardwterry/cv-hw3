function M = LucasKanadeAffine(It, It1)

% input - image at time t, image at t+1
% output - M affine transformation matrix
% rect = uint16(rect); % converting to integers so it doesn't complain
% T = It(rect(2):rect(4),rect(1):rect(3)); % create a template based on It. Updates every frame
T = It;
% band = .2;

[x,y,~]=size(It);
% rect = [floor(band/2*y);floor(band/2*x);ceil((1-(band/2))*y);ceil((1-(band/2))*x)];
% crop both images
% T = It(rect(2):rect(4),rect(1):rect(3)); % create a template based on It. Updates every frame
% It1 = It1(rect(2):rect(4),rect(1):rect(3));
% [xt,yt,~]=size(T);

% [xt,yt,~]=size(T);
p = zeros(6,1);
% M = [1+p(1) p(2) p(3);p(4) 1+p(5) p(6);0 0 1]; % initial guess for p

eps = 1e-3; % convergence threshold
[It1x,It1y] = gradient(It1);

[U,V] = meshgrid(1:y,1:x); % x and y coordinates of rectangle
c=cat(2,U',V');
coords=double([reshape(c,[],2) ones(size(U,1)*size(U,2),1)]);

i = 1;
metric = 1;
metric_difference = 1;

    for i = 1:(x*y)
        J(:,:,i) = [coords(i,2) 0 coords(i,1) 0 1 0; 0 coords(i,2) 0 coords(i,1) 0 1];
    end
A = zeros(length(coords),6);
while metric_difference>eps
    % warp I with W(x,p) to compute I(W(x,p))
    M = [1+p(1) p(2) p(3);p(4) 1+p(5) p(6);0 0 1];
    warped_coords = (M*coords')'; %
    Vq = reshape(warped_coords(:,2),[y,x])'; % make into equivalent meshgrids to above
    Uq = reshape(warped_coords(:,1),[y,x])';
    I_w = interp2(It1,Uq,Vq); % warped It1
    %     I_w_crop = I_w(rect(2):rect(4),rect(1):rect(3));
    
    % compute error image
    bc = T-I_w;%_crop;
    bc_col = reshape(bc,[x*y,1]);
    
    % warp gradient delI with W(x,p)
    delIx_w = interp2(It1x,Uq,Vq);
    %     delIx_w_crop = delIx_w(rect(2):rect(4),rect(1):rect(3));
    delIy_w = interp2(It1y,Uq,Vq);
    %     delIy_w_crop = delIy_w(rect(2):rect(4),rect(1):rect(3));
    delIcol = [reshape(delIx_w,[x*y,1]) reshape(delIy_w,[x*y,1])];
    delIstack = reshape(delIcol,[1,2,76800]);
%     delIcol_crop = [reshape(delIx_w_crop,[xt*yt,1]) reshape(delIy_w_crop,[xt*yt,1])];
    
    % evaluate Jacobian at (x,p)
        
%     delIfirstCol = sparse(diag(delIcol(:,1)));
%     delIsecondCol = diag(delIcol(:,2));
%     
%     delIcol_sparse = reshape([delIfirstCol(:) delIsecondCol(:)]',2*size(delIfirstCol,1), [])';
% %     delIcol_sparse = reshape([diag(delIcol(:,1)) diag(delIcol(:,2))]',2*size(diag(delIcol(:,1)),1), [])';
%     
%     fun = @(x,y) [x zeros(length(x),1) y zeros(length(x),1) ones(length(x),1) zeros(length(x),1)];
%     Jrow1 = fun(coords(:,1),coords(:,2));
%     Jrow2 = circshift(Jrow1,[0,1]);
%      
%     J_vect = reshape([Jrow1(:) Jrow2(:)]',2*size(Jrow1,1), []);
%     A = delIcol_sparse*J_vect;
%     test = col_interleave*row_interleave;
    for i = 1:length(delIcol)
%         J(:,:,i) = [coords(i,2) 0 coords(i,1) 0 1 0; 0 coords(i,2) 0 coords(i,1) 0 1];
        A(i,:) = delIstack(1,:,i)*J(:,:,i);
    end
    %             J = [x 0 y 0 1 0; 0 x 0 y 0 1];
    
    % compute steepest descent images: delI * Jacobian
    %     A = delIcol*J;
    
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

% M = [1+p(1) p(2) p(3); p(4) 1+p(5) p(6); 0 0 1];

end