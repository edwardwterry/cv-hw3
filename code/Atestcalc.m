[U,V] = meshgrid(1:5,1:3); % x and y coordinates of rectangle
c=cat(2,U',V');
coords=double([reshape(c,[],2)]);% ones(size(U,1)*size(U,2),1)]);

J = [3 0 4 0 1 0; 0 3 0 4 0 1];