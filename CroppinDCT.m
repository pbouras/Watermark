function [ variable,other,res ] = CroppinDCT( wholeImg,waterImg,key,blockR, blockC,areas)

rect = [50 50 149 149];
myarray = imcrop(wholeImg,rect);
figure()
imshow(myarray,[])
theImg = zeros(256,256);
theImg(50:199,50:199) = myarray;
figure()
imshow(theImg,[])

counter = 0;
theImg = double(theImg);
newImg = mat2cell(theImg, blockR, blockC);
x = size(newImg);

if (areas == 32)
    sz = [8,8];
else
    sz = [16,16];
end

[ro,co] = ind2sub(sz,key);
a = 0.1;

for p = 1:x(1)
    for j = 1:x(2)
        myblock = newImg{p,j};
        mydct = dct2(myblock);
        counter = counter + 1;
        mywater = waterImg{co(counter),ro(counter)};
        theMatrix = sum(mydct(:).*mywater(:));
        M = length(mydct(:));
        %theMatrix = corrcoef(mydct,mywater);
        theMatrix = theMatrix / M;
        variable(p,j) = theMatrix;
        
        %threshold
        T = (a  * sum(mydct(:)));
        T = T / 3*M;
        T = T / 10^6;
        
        other(p,j) = T;     
        if (theMatrix >= T )
            res(p,j) = 1;
        else
            res(p,j) = 0;
        end
        
    end



end
