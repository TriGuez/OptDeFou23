function T = VertSlit(X, Y, yc, Width)

T =double(X<yc+(Width/2) & X>yc-(Width/2));