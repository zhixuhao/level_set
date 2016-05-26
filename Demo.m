%  2016.3?  ??cv???li's???????LSF??
%
%
%  ??????????????????????????????????????
%  ?????????????????????????????????
%  ???????????????cv???????????????????????????hsv?????????
%  li's??????????????????????????????????????????????????
%  ??????????????????????????????????????
%  ???c0???????LSF???????????color_space???????hsv????
%  edge_detector,?????????????canny?????????????????????????????graident???
%  ?canny?????????????????Img_gray?????????.??cha_c??hsv?????????????????
%  ????????????????
%  mu???????????????
%
%
%% init parameters 
imgname = 'teddy.jpg';
Img = imread(imgname);
Img_hsv = rgb2hsv(Img);
Img_gray = rgb2gray(Img);
size_img = size(Img_gray);
Img_gray = double(Img_gray);
timestep = 1;  % time step
mu = 0.2/timestep;  % coefficient of the distance regularization term R(phi)
max_iter = 15;
in_iter = 1;
lambda1 = 1; % 
lambda2 = 1; % 
alfa = 5;  % coefficient of the weighted length term L(phi)
epsilon = 1.5; % papramater that specifies the width of the DiracDelta function
color_space = 'hsv';
edge_detector = 'gradient';
threshold_one = 1;%?????????
threshold_two = 0.02*3;%?????????
energy = [];
saliency = Saliency(Img);
bw = im2bw(saliency);
se = strel('disk',15);
afterOpening = imdilate(bw,se);
saliency = saliency.*255;

%% choose color space
if(strcmp(color_space,'hsv'))
    Img_gray = hsv_gray(Img_hsv,1,1,0);
    Img_gray = Img_gray.*255;
end
sigma = .8;    % scale parameter in Gaussian kernel
G = fspecial('gaussian',3,sigma); % Caussian kernel
Img_smooth = conv2(Img_gray,G,'same');  % smooth image by Gaussiin convolution

[Ix,Iy] = gradient(Img_smooth);
f = Ix.^2+Iy.^2;
if(strcmp(edge_detector,'canny'))
    canny = edge(Img_smooth,'canny');
    f = f.*canny;
end
g = 1./(1+f);  % edge indicator function.
if(strcmp(edge_detector,'canny'))
    g = conv2(g,G,'same');
end
%% init LSF
c0=1;
img_size = size(Img_gray);
initialLSF = c0*ones(img_size);
rows = img_size(1,1);
cols = img_size(1,2);
for i=1:rows
    for j=1:cols
        initialLSF(i,j) = c0*sin((i-1).*pi/4500.0.*size_img(1)).*sin((j-1).*pi/4500.0.*size_img(2));
    end
end
% initialLSF = c0*ones(img_size);
% initialLSF = initialLSF.*-1;
% afterOpening = afterOpening.*2;
% initialLSF = initialLSF+afterOpening;
phi = initialLSF.*-1;
%% write gif
figure(1);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r','LineWidth',2);
%title('Initial zero level contour');

F = getframe(1);
im = frame2im(F);
[X,map] = rgb2ind(im,256);
imwrite(X,map,strcat('results/',imgname,color_space,'.gif'),'gif','LoopCount',inf,'DelayTime',0.2);

%% start iteration
phi_cha = [];
flag = 0;
saliency = Saliency(Img);
saliency = saliency.*255;
for n=1:max_iter
    
    
    
    sa = ave_saliency(saliency,phi);
    w_h = 0.0;
    w_s = 0.0;
    w_v = 0.1;
    w_sa = 0.1;
    if strcmp(color_space,'hsv') 
        
        c = ave_hsv(Img_hsv,phi);%hsv
        cha_c = color_c(Img_hsv,Img_gray,saliency,'hsv',c,sa,lambda1,lambda2,w_h,w_s,w_v,w_sa);%hsv
        %energy = [energy Energy(Img_hsv,'hsv',mu,alfa,lambda1,lambda2,f,g,c,phi)];
    elseif strcmp(color_space,'rgb') 
        c = ave(Img,phi);%rgb
        cha_c = color_c(Img,Img_gray,saliency,'rgb',c,sa,lambda1,lambda2,0.1,0.1,0.1,0.0);%rgb
        %energy = [energy Energy(Img,'rgb',mu,alfa,lambda1,lambda2,f,g,c,phi)];
    else
        c = ave(Img,phi);%rgb
        cha_c = color_c(Img,Img_gray,'rgb',c,lambda1,lambda2);%rgb
        %energy = [energy Energy(Img,'rgb',mu,alfa,lambda1,lambda2,f,g,c,phi)];
    end
    
    cha_c = cha_c*0.1;
    if n>25 || flag == 1
        cha_c = 0;
        mu = 0.1;
        
    end
    
    phia = im2bw(phi,0);
    last_phia = phia;
    phi = drlse_edge(phi,g,alfa,epsilon,mu,timestep,in_iter,cha_c);  
    phia = im2bw(phi,0);
    tmp_phi_cha = (sum(sum(abs(phia - last_phia)))+0.0)/(size_img(1).*size_img(2)).*100;
    if tmp_phi_cha < 1
        flag = 1;
    end
    phi_cha = [phi_cha;tmp_phi_cha];
    if mod(n,2)==0
        pause(0.1)
        figure(1);
        imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r','LineWidth',2);
        title(['zero level contour at frame: ' num2str(n)]);
        F = getframe(1);
        im = frame2im(F);
        [X,map] = rgb2ind(im,256);
        imwrite(X,map,strcat('results/',imgname,color_space,'.gif'),'gif','Delaytime',0.2,'WriteMode','append');
    end
    if n > 15 
        if phi_cha(n) + phi_cha(n-1) + phi_cha(n-2) < 0.03*1
            break;
        end
    end
   
end
figure(2);
%mesh(-phi);   % for a better view, the LSF is displayed upside down
%hold on;  contour(phi, [0,0], 'r','LineWidth',2);
%title('level set function');
%view([-80 35]);
phi = -1.*phi;
phia = im2bw(phi,0);
prefix = 'final_';
w_imgname = ['results/',prefix,color_space,imgname];
imwrite(phia,w_imgname);
figure(3);
imshow(phia);








