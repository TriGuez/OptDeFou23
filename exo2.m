clear
close all

obj = (imread("ENSSAT_1750x1750.jpg"));
obj = double(obj(:,:,1)./255);

dx = 1e-6;
dy = 1e-6;
[M,N] = size(obj);
x = (-M/2:M/2-1)*dx;
y = (-N/2:N/2-1)*dy;

imagesc(x*1e3,y*1e3,obj)
colormap gray
axis equal
title('Image initiale')
xlabel('x (mm)')
ylabel('y (mm)')

S = fftshift(fft2(obj)./(M*N));
W = dx*M;
H = dy*N;

dfx = 1/W;
dfy = 1/H;

fx = (-M/2:M/2-1)*dfx;
fy = (-N/2:N/2-1)*dfy;

figure()
imagesc(fx*1e-3,fy*1e-3,log(abs(S).^2))
colormap gray
axis equal
xlabel('fx (1/mm)')
ylabel("fy (1/mm)")
title("Spectre de Fourier de l'objet initial")


lambda = 500e-9;
k0 = 2*pi/lambda;
fpA = 1;
xf = lambda.*fpA.*fx;
yf = lambda.*fpA.*fy;
[Xf,Yf] = meshgrid(xf,yf);
masque = HorSlit(Xf,Yf,0,10e-3);
kappa1 = (exp(1i*k0*fpA)./(1i*lambda*fpA));
ImF = kappa1.*S;

figure()
imagesc(xf*1e3,yf*1e3,log(abs(ImF)).^2)
colormap gray
xlabel('xf (mm)')
ylabel("yf (mm)")
title("Image dans le plan de Fourier du montage 4f")

fpB = 10e-3;
x4 = fx.*fpB.*lambda;
y4 = fy.*fpB.*lambda;
kappa2 = (exp(1i*k0*fpB)./(1i*lambda*fpB));
IM = fft2(fftshift(masque.*ImF.*kappa2)./(M*N));
figure()
imagesc(x4*1e3,y4*1e3,abs(IM).^2)
colormap gray
xlabel('x4 (mm)')
ylabel("y4 (mm)")
title("Image dans le plan focal de la lentille B")