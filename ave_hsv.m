function c = ave_hsv(img,phi_a)
img = img.*255;
imgh = img(:,:,1);
imgs = img(:,:,2);
imgv = img(:,:,3);
size_img = size(imgh);
rows = size_img(1,1);
cols = size_img(1,2);
sumh_in = 0;
sums_in = 0;
sumv_in = 0;
sumh_out = 0;
sums_out = 0;
sumv_out = 0;
count_in = 0;
count_out = 0;
for i = 1:rows
    for j = 1:cols
        if phi_a(i,j) >= 0
            count_in = count_in + 1;
            sumh_in = sumh_in + double(imgh(i,j));
            sums_in = sums_in + double(imgs(i,j));
            sumv_in = sumv_in + double(imgv(i,j));
        else
            count_out = count_out + 1;
            sumh_out = sumh_out + double(imgh(i,j));
            sums_out = sums_out + double(imgs(i,j));
            sumv_out = sumv_out + double(imgv(i,j));
        end
    end
end
c = [sumh_in/count_in sums_in/count_in sumv_in/count_in;
    sumh_out/count_out sums_out/count_out sumv_out/count_out];
        
        