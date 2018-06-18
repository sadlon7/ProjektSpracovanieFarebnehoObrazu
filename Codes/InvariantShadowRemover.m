%% Removing shadow (entrophy + invariant)

clear all;
close all;
clc;

size = 500
b=imread('shadow3.jpg');
b=imresize(b, [size, size]);
a=double(b);

figure; subplot(2,2,1); imshow(b); title('Original');

epsilon = 1e-3;
I=find(a==0);
a(I)=epsilon;

r_b=log(a(:,:,1)./a(:,:,3));
g_b=log(a(:,:,2)./a(:,:,3));
l = 1;
B = zeros(1,40000);
R = zeros(1,40000);
for i = 1:size
   for j = 1:size
    B(l) = g_b(i,j);
    l = l+1;
   end
end
m = 1;
for i = 1:size
    for j = 1:size
        R(m) = r_b(i,j);
        m = m+1;
    end
end

subplot(2,2,2); plot(R,B,'o'); title('Entropy');

%% Calculating invariant angle
deg = CalculateInvariantAngle(r_b, g_b);
% deg=51;
rad = deg*(pi/180);
inv = (cos(rad)*(r_b) - sin(rad)*(g_b));
invexp = exp(inv);
invexp=invexp-min(min(invexp));
invexp=invexp*255/max(max(invexp));
% figure;
% imshow(invexp, [0 255]);

%% Clustering into 2 clusters
x= (max(g_b(:)) + min(g_b(:)))/2;
c1=g_b(find(g_b >= x));
c2=g_b(find(g_b < x));
mc1=median(c1);
mc2=median(c2); 
for i=1:size    
    for j=1:size
        if(g_b(i,j) >=x)
            logresRG(i,j) = inv(i,j)*cos(-rad) + mc1*sin(-rad);
            logresBG(i,j) = -inv(i,j)*sin(-rad) + mc1*cos(-rad);            
        else
            logresRG(i,j) = inv(i,j)*cos(-rad) + mc2*sin(-rad);
            logresBG(i,j) = -inv(i,j)*sin(-rad) + mc2*cos(-rad);                        
        end
    end
end
resRG = exp(logresRG);
resBG = exp(logresBG);


B =(3*invexp)./ (resRG + resBG +1);
B=B-min(B(:));
B=B/(max(B(:)));

R = resRG.*B;
R=R-min(R(:));
R=R/(max(R(:)));

G = resBG.*B;
G=G-min(G(:));
G=G/(max(G(:)));

rgb(:,:,1)=R;
rgb(:,:,2)=G;
rgb(:,:,3)=B/2;
 
%% Showing result
subplot(2,2,3); imshow((rgb2gray(rgb))); title('Gray Scale');
subplot(2,2,4); imshow(rgb); title('RGB');