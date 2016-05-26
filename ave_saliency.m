function sa = ave_saliency(saliency,phi)

size_img = size(saliency);
rows = size_img(1,1);
cols = size_img(1,2);
sum_in = 0;
sum_out = 0;
count_in = 0;
count_out = 0;
for i = 1:rows
    for j = 1:cols
        if phi(i,j) >= 0
            count_in = count_in + 1;
            sum_in = sum_in + double(saliency(i,j));
        else
            count_out = count_out + 1;
            sum_out = sum_out + double(saliency(i,j));
           
        end
    end
end
sa = [sum_in/count_in;
    sum_out/count_out];

end