x = -5:0.2:5;
y = -5:0.2:5;
[X,Y] = meshgrid(x,y);
vx = X.^2 - Y.^2;
vy = -2*X.*Y;
quiver(x,y,vx,vy)
axis equal, axis tight

