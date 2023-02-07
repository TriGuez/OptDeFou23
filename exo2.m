clear
close all

% Lecture de l'image a traiter
obj = (imread("ENSSAT_1750x1750","jpg"));
obj = double(obj(:,:,1))/255; % On normalise l'image entre 0 & 1

% Définition des variables spatiales de l'image
dx = 1e-4; % 1 pixel = 0.1 mm
dy = 1e-4; 
[M,N] = size(obj);
x = (-M/2:M/2-1)*dx;
y = (-N/2:N/2-1)*dy;
% Définition des variables fréquentielles. Pour rappel : 
% fx_max = 1/dx, fy_max = 1/dy
% dfx = 1/xmax, dfy = 1/ymax
W = M*dx;
H = N*dy;
dfx = 1/W;
dfy = 1/H;
fx = (-M/2:M/2-1)*dfx;
fy = (-N/2:N/2-1)*dfy;
[Fx, Fy] = meshgrid(fx, fy);
% Définition des variables spatiales dans le plan de Fourier du montage
lambda = 500e-9;
fa =1; % Focale de la première lentille 
fb = 0.1; % focale de la seconde lentille
xF = fx*lambda*fa;
yF = fy*lambda*fa;
[Xf, Yf] = meshgrid(xF, yF);
% Définition des variables spatiales dans le plan image du montage
x_im = (fb/fa)*x;
y_im = (fb/fa)*y;


% On affiche l'objet initial
imagesc(x*1e3,y*1e3,obj) % On affiche l'objet avec une échelle en mm
colormap gray
title('Image initiale')
xlabel('x (mm)')
ylabel('y (mm)')

% On calcule l'image de l'objet initial dans le plan de Fourier du montage,
% c-à-d dans le plan focal de la première lentille. Comme nous travaillons
% en normalisé, nous pouvons nous affranchir des termes de phase de l'eq 
% (1.1), qui se résume donc à une transformation de Fourier
ampSpectrum = fftshift(fft2(obj));
Spectrum = abs(ampSpectrum).^2;
Spectrum = Spectrum./(max(max(Spectrum))); % Normalisation de l'intensité
% du spectre. 

% On affiche le spectre en fonction des fréquences spatiales fx et fy 

figure()
imagesc(fx/1e3,fy/1e3,log(Spectrum))
colormap gray
title('Spectre image initiale (domaine frequentiel)')
xlabel('fx (mm^{-1})')
ylabel('fy (mm^{-1})')

% En pratique, l'oeil n'a pas accès aux fréquences spatiales. Nous
% affichons donc le même spectre dans les coordonées spatiales du plan de
% Fourier. On remarque bien une focalisation.

figure()
imagesc(xF/1e-3,yF/1e-3,(Spectrum))
colormap gray
title('Spectre image initiale (domaine spatial)')
xlabel('xF (mm)')
ylabel('yF (mm)')

% On défini les différents filtres a appliquer sur le spectre de Fourier de
% l'objet initial. On peut définir ces masques soit suivant les fréquences
% spatiales, et donc définir leurs dimensions en 1/m, ou dans le domaine
% spatial, et donc leurs dimensions en m
Filtre1 = HorSlit(Fx,Fy,0,400);
Filtre2 = VertSlit(Fx,Fy,0,400);
Filtre3 = Filtre1.*Filtre2;
Filtre4 = HorSlit(Fx,Fy,0,800).*VertSlit(Fx,Fy,0,800);
Filtre5 = Filtre4.*AntiSquare(Fx,Fy,0,0,250);
Filtre6 = Filtre2.*AntiSquare(Fx, Fy, 0,0,250);
Filtre7 = Filtre1.*AntiSquare(Fx, Fy, 0,0,250);
Filtre8 = -1*(1-AntiSquare(Fx,Fy,0,0,1600)).*AntiSquare(Fx,Fy,0,0,800);

% On applique le filtre sélectionné au spectre de Fourier de l'objet
% initial.
Filt_ampSpectrum = Filtre1.*ampSpectrum;

% On affiche le spectre de Fourier filtré
figure()
imagesc(fx/1e3,fy/1e3,log(abs(Filt_ampSpectrum).^2))
colormap gray
title('Spectre image initiale')
xlabel('fx (mm^{-1})')
ylabel('fy (mm^{-1})')

% On calcule l'image dans le plan image du montage 4F, d'après l'équation
% (1.3). Encore une fois, nous  pouvons nous affranchir des termes de phase
ampImage = (fft2(Filt_ampSpectrum));
Image = abs(ampImage).^2;
Image = Image./(max(max(Image)));

% On affiche finalement l'image filtrée (renversée).
figure()
colormap gray
imagesc(-x_im/1e-3,-y_im/1e-3,Image)
xlabel('x_{im} (mm)')
ylabel('y_{im} (mm)')
title('Image finale')
