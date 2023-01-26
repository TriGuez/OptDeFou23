clear
close all
set(0,"DefaultFigureColormap",feval("gray"));
M = 2^8;

dx = 20e-3/M;
x = (-M/2:1:M/2-1)*dx;
y = x;
[X, Y] = meshgrid(x,y);

Dx = 5e-3;
T = sin(2*pi*X./Dx);
figure()
imagesc(x,y,T)

W = M*dx;
dfx = 1/W;
fx = (-M/2:1:M/2-1)*dfx;
fy = fx;

S = fftshift(fft2(T))./(M*M);
figure()
imagesc(fx,fy,abs(S).^2)

S2 = fftshift(fft2(T'))./(M*M);
figure()
imagesc(fx,fy,abs(S2).^2)

Tbin = T>0.5;

figure()
imagesc(x,y,Tbin)
S3 = fftshift(fft2(Tbin))./(M*M);
figure()
imagesc(fx,fy,abs(S3).^2)