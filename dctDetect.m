function [ variable,other,results ] = dctDetect( wholeImg, waterImg,key,blockR, blockC,areas)
[rows, cols] = size(wholeImg);
%{
theNumbers = normrnd(0,1,256);
waterImg = mat2cell(theNumbers, blockR, blockC);
%}

snr = 10;

varImg = sum(sum(double(wholeImg(:,:)) .^ 2))/(rows*cols);
var = sqrt(varImg / 10^(snr/10));
mynoise(:,:) = var * randn(rows, cols);
noImg = double(wholeImg) + mynoise;

%noImg = uint8(noImg);
figure();
imshow(noImg, []);

counter = 0;

%noImg = double(noImg);
ceNoiseImg = mat2cell(noImg, blockR, blockC);
x = size(ceNoiseImg);
if (areas == 32)
    sz = [8,8];
else
    sz = [16,16];
end
[ro,co] = ind2sub(sz,key);
a = 0.1;

for p = 1:x(1)
    for j = 1:x(2)
        myblock = ceNoiseImg{p,j};
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
            results(p,j) = 1;
        else
            results(p,j) = 0;
        end
    end
    
    
    
end