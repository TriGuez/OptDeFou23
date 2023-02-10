clear
close all

% Définition du nombre de points de l'image :

M = 2^4; % 512 points, à modifier uniquement par puissances de 2
N = M; % On cherche ici à obtenir une image carrée, donc on fixe le même nombre de points

% Définition des axes x & y :

xmax = 20e-3; % Taille de l'image selon x, en m
ymax = 20e-3; % Taille de l'image selon y, en m
dx = xmax/M; % Définition des pas spatiaux suivant x & y
dy = ymax/N; 
x = (-M/2:M/2-1)*dx; % ou x = linspace(-xmax/2,xmax/2,M);
y = (-N/2:N/2-1)*dy; % ou y = linspace(-ymax/2,ymax/2,N);

% Définition de la grille 2D :
[X, Y] = meshgrid(x,y);

% Définition de l'objet d'amplitude :

Dx = 1e-3; % Période de la sinusoïde suivant x
T = sin(2*pi/Dx.*X); % Sinusoïde suivant X
% affichage :

figure()
imagesc(x.*1e3,y.*1e3,T);
colormap gray
xlabel("x (mm)", "FontSize",14)
ylabel("y (mm)", "FontSize",14)
axis equal
title("Objet d'amplitude initial", "FontSize",16)
figure()
plot(x*1e3,T(M/2,:))
xlabel("x (mm)", "FontSize",14)
ylabel("$T \vert_{x=0}$","Interpreter","latex", "FontSize",20)
ylim([-1.1 1.1])
title("Projection selon x", "FontSize",16)
figure()
plot(y*1e3,T(:,N/2))
xlabel("y (mm)", "FontSize",14)
ylabel("$T \vert_{y=0}$",'Interpreter','latex', "FontSize",20)
title("Projection selon y", "FontSize",16)
% Calcul du spectre de Fourier de l'image initiale

% Définition du domaine de Fourier dual de l'espace xy défini précédemment
W = dx*M; 
H = dy*N; % Calcul de la hauteur et de la largeur du domaine

dfx = 1/W;
dfy = 1/H; % Calcul de la résolution fréquentielle suivant les deux directions

% Création des vecteurs fx et fy de fréquences spatiales :
fx = (-M/2:M/2-1)*dfx;
fy = (-N/2:N/2-1)*dfy;

% Création de la grille de fréquences spatiales :
[Fx, Fy] = meshgrid(fx,fy);

% Calcul du spectre de Fourier de l'image initiale :
S = fftshift(fft2(T)./(M*N));

% Affichage :

figure()
imagesc(fx,fy,(abs(S).^2))
xlabel('fx $(m^{-1})$', 'Interpreter','latex','FontSize',14)
ylabel('fy $(m^{-1})$', 'Interpreter','latex','FontSize',14)
title('Spectre de Fourier de l''image initiale', "FontSize",16)
colormap gray
% Transformation de l'objet d'amplitude en objet d'amplitude binaire

T = T>0.5; % Utilisation de l'indexation logique pour transformer un sinus en créneau

% affichage de l'objet :

figure()
imagesc(x*1e3,y*1e3,T);
colormap gray
xlabel("x (mm)", "FontSize",14)
ylabel("y (mm)", "FontSize",14)
axis equal
title("Objet d'amplitude binaire", "FontSize",16)

% Calcul du spectre de Fourier de l'image binaire :
S = fftshift(fft2(T)./(M*N));

% Affichage :

figure()
imagesc(fx,fy,abs(S).^2)
xlabel('fx $(m^{-1})$', 'Interpreter','latex','FontSize',14)
ylabel('fy $(m^{-1})$', 'Interpreter','latex','FontSize',14)
title('Spectre de Fourier de l''image binaire', "FontSize",16)
colormap gray