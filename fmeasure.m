function f = fmeasure(imgname,img_bname)
img = imread(imgname);
img_b = imread(img_bname);
if(strcmp(class(img),'logical'))
    img = img.*255;
end
if(strcmp(class(img_b),'logical'))
    img_b = img_b.*255;
end
f=[0,0,0];
s = size(img);
sum_img = 0;
sum_img_b = 0;
sum_right = 0;
for i = 1:s(1)
    for j = 1:s(2)
        if(img(i,j)>100)
            sum_img = sum_img+1;
            if(img_b(i,j)>100)
                sum_right = sum_right+1;
            end
        end
        if(img_b(i,j)>100)
            sum_img_b = sum_img_b+1;
        end
    end
end
f(1) = sum_right/sum_img;
f(2) = sum_right/sum_img_b;
f(3) = 2*f(1)*f(2)/(f(1)+f(2));
