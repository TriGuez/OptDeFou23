clear
close all

obj = (imread("ENSSAT_1750x1750","jpg"));
obj = double(obj(:,:,1))/255;

dx = 1e-4;
dy = 1e-4;
[M,N] = size(obj);
x = (-M/2:M/2-1)*dx;
y = (-N/2:N/2-1)*dy;
W = M*dx;
H = N*dy;
dfx = 1/W;
dfy = 1/H;
fx = (-M/2:M/2-1)*dfx;
fy = (-N/2:N/2-1)*dfy;
[Fx, Fy] = meshgrid(fx, fy);


imagesc(x*1e3,y*1e3,obj)
colormap gray
axis equal
title('Image initiale')
xlabel('x (mm)')
ylabel('y (mm)')

ampSpectrum = fftshift(fft2(obj));
Spectrum = abs(ampSpectrum).^2;
Spectrum = Spectrum./(max(max(Spectrum)));

figure()
imagesc(fx/1e3,fy/1e3,log(Spectrum))
colormap gray
axis equal
title('Spectre image initiale')
xlabel('fx (mm^{-1})')
ylabel('fy (mm^{-1})')

lambda = 500e-9;
fa =1;
fb = 0.1;
xF = fx*lambda*fa;
yF = fy*lambda*fa;

Filtre1 = HorSlit(Fx,Fy,0,400);
Filtre2 = VertSlit(Fx,Fy,0,400);
Filtre3 = Filtre1.*Filtre2;
Filtre4 = HorSlit(Fx,Fy,0,800).*VertSlit(Fx,Fy,0,800);
Filtre5 = Filtre4.*AntiSquare(Fx,Fy,0,0,250);
Filtre6 = Filtre2.*AntiSquare(Fx, Fy, 0,0,250);
Filtre7 = Filtre1.*AntiSquare(Fx, Fy, 0,0,250);

Filt_ampSpectrum = Filtre7.*ampSpectrum;
ampImage = (fft2(Filt_ampSpectrum));
Image = abs(ampImage).^2;
Image = Image./(max(max(Image)));
x_im = (fb/fa)*x;
y_im = (fb/fa)*y;
figure()
colormap gray
axis equal
imagesc(-x_im/1e-3,-y_im/1e-3,Image)
