function energy = Energy(img,mode,mu,alpha,l1,l2,f,g,c,phi)
if strcmp(mode,'hsv')
    img = img.*255;
end
size_img = size(img(:,:,1));
rows = size_img(1,1);
cols = size_img(1,2);
abs_f = sqrt(f);
phi_g = (1-abs_f).^2;
mu_phi = sum(sum(phi_g)).*mu;
dirac_phi = Dirac(phi,0.8);
alpha_phi = sum(sum(g.*dirac_phi.*abs_f)).*alpha;
c_cha = 0;
h_phi = Heaviside(phi);
for i = 1:rows
    for j = 1:cols
        tmp = l1.*h_phi(i,j).*((img(i,j,1)-c(1,1)).^2+(img(i,j,2)-c(1,2)).^2+(img(i,j,3)-c(1,3)).^2) + l2.*(1-h_phi(i,j)).*((img(i,j,1)-c(2,1)).^2+(img(i,j,2)-c(2,2)).^2+(img(i,j,3)-c(2,3)).^2);
        c_cha = c_cha + tmp;
    end
end
energy = mu_phi + alpha_phi;
end

