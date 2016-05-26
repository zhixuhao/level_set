function c = ave(img,phi_a)
imgr = img(:,:,1);
imgg = img(:,:,2);
imgb = img(:,:,3);
size_img = size(imgr);
rows = size_img(1,1);
cols = size_img(1,2);
sumr_in = 0;
sumg_in = 0;
sumb_in = 0;
sumr_out = 0;
sumg_out = 0;
sumb_out = 0;
count_in = 0;
count_out = 0;
for i = 1:rows
    for j = 1:cols
        if phi_a(i,j) >= 0
            count_in = count_in + 1;
            sumr_in = sumr_in + double(imgr(i,j));
            sumg_in = sumg_in + double(imgg(i,j));
            sumb_in = sumb_in + double(imgb(i,j));
        else
            count_out = count_out + 1;
            sumr_out = sumr_out + double(imgr(i,j));
            sumg_out = sumg_out + double(imgg(i,j));
            sumb_out = sumb_out + double(imgb(i,j));
        end
    end
end
c = [sumr_in/count_in sumg_in/count_in sumb_in/count_in;
    sumr_out/count_out sumg_out/count_out sumb_out/count_out];
        
        