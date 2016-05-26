function c_cha = color_c(img,img_gray,sliency,mode,c,sa,l1,l2,c1,c2,c3,s)
img = double(img);
if strcmp(mode,'hsv')
    img = img.*255;
end
size_img = size(img_gray);
rows = size_img(1,1);
cols = size_img(1,2);
c_cha = ones(size_img);
for i = 1:rows
    for j = 1:cols
          c_cha(i,j) = -l1.*(c1.*(img(i,j,1)-c(1,1)).^2+c2.*(img(i,j,2)-c(1,2)).^2+c3.*(img(i,j,3)-c(1,3)).^2+s.*(sliency(i,j)-sa(1,1)).^2) + l2.*(c1.*(img(i,j,1)-c(2,1)).^2+c2.*(img(i,j,2)-c(2,2)).^2+c3.*(img(i,j,3)-c(2,3)).^2+s.*(sliency(i,j)-sa(2,1)).^2);
    end
end