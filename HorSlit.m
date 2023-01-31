function T = HorSlit(X, Y, xc, Width)

T =double(Y<xc+(Width/2) & Y>xc-(Width/2));