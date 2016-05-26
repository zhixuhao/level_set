function c_cha = color_c_hsv(img,img_gray,c,l1,l2,h,s,v)
img = double(img);
img = img.*255;
size_img = size(img_gray);
rows = size_img(1,1);
cols = size_img(1,2);
c_cha = ones(size_img);
for i = 1:rows
    for j = 1:cols
          c_cha(i,j) = -l1.*(h.*(img(i,j,1)-c(1,1)).^2+s.*(img(i,j,2)-c(1,2)).^2+v.*(img(i,j,3)-c(1,3)).^2) + l2.*(h.*(img(i,j,1)-c(2,1)).^2+s.*(img(i,j,2)-c(2,2)).^2+v.*(img(i,j,3)-c(2,3)).^2);
    end
end