function cv_red = cv_to_red(img)
cv_red = img;
s = size(img);
for i= 1:s(1)
    for j = 1:s(2)
        if((cv_red(i,j,3) - cv_red(i,j,1) > 60)&& (cv_red(i,j,3) - cv_red(i,j,2)>60))
            cv_red(i,j,1)=255;
            cv_red(i,j,2)=0;
            cv_red(i,j,3)=0;
        end
    end
end
imshow(cv_red);