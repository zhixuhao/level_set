function img = hsv_gray(img_in,h,s,v)
imgh = img_in(:,:,1);
imgs = img_in(:,:,2);
imgv = img_in(:,:,3);
img = (h.*imgh + s.*imgs + v.*imgv)./(h+s+v);
