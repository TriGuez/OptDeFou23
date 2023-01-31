function T = AntiSquare(X, Y, xc, yc, Width)

T = double(~((HorSlit(X,Y,xc,Width))&(VertSlit(X,Y,yc,Width))));