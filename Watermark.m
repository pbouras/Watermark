img = load('Eikona1.mat');
img = img.flower;
[rows, cols,dim] = size(img);

L = double(max(max(img(:,:))));
l = double(min(min(img(:,:))));

%image
img(:,:) = (double((img(:,:)) - l).*255) ./ (L-l);
img = uint8(img);

areas = 32; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% block changer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%random numbers between 0-1 
randomNumbers = normrnd(0,1,256);

%key-for-watermark
if (areas == 32)
    key = randperm(64);
else
    key = randperm(256);
end


figure()
imshow(img,[])
figure()
imshow(randomNumbers,[])


split = rows / areas;
blockR = (areas * ones(1, split));
% Figure out the size of each block in columns.
blockC = (areas * ones(1, split));


ceImg = mat2cell(img, blockR, blockC);
waterImg = mat2cell(randomNumbers, blockR, blockC);

x = size(ceImg);
c = 1;
w = 1;

if (areas == 32)
    sz = [8,8];
else
    sz = [16,16];
end

[ro,co] = ind2sub(sz,key);
counter = 0;
a = 0.1;

figure()
for p = 1:x(1)
    for j = 1:x(2)
        myblock = ceImg{p,j};
        mydct = dct2(myblock);
        
        counter = counter + 1;
        mywater = waterImg{co(counter),ro(counter)};
        
        ndct = mydct .* (1 + a*mywater);
        %ndct = mydct + mywater;
        
        newImg = idct2(ndct);
        newImg = uint8(newImg);
        subplot(x(1), x(2), c);
        imshow(newImg);
        c = c + 1;
        wholeimg{p,j} = newImg;
    end
end


wholeImg = cell2mat(wholeimg);
figure()
imshow(wholeImg,[]) 


[var,oth,results] = dctDetect(wholeImg,waterImg,key,blockR, blockC,areas);

oth = oth(:);
mymean = mean(oth);
var = var(:);

figure()
plot(var,'-o')
hold on;
plot(mymean*ones(size(var)))


[variable,other,res] = CroppinDCT(wholeImg,waterImg,key,blockR, blockC,areas);

other = other(:);
mesos = mean(other);
variable = variable(:);

figure()
plot(variable,'-o')
hold on;
plot(mesos*ones(size(variable)))



sum(results(:) == 0)
sum(results(:) == 1)

sum(res(:) == 0)
sum(res(:) == 1)
