function Ifinal1=evalSegment(Igt,Iresult)
%Igt = imread('GroundTrue3.png');
Igt = Igt(:,:,1);
%Igt =resize(Igt, [500 500]);
%Iresult = imread('resultadoMRF3_color.png');
Iresult = Iresult(:,:,1);

[f,c] = size(Igt);
Ifinal = zeros(f,c,3);
Ifinal1 = zeros(f,c,3);


Iand = and(Igt,Iresult);
Ixor = xor(Igt,Iresult);

Ifinal(:,:,1) =  Iand*255;
Ifinal(:,:,3) =  Ixor*255;

subplot(1,3,1);
imshow(Igt);
subplot(1,3,2);
imshow(Iresult);
subplot(1,3,3);
imshow(Ifinal);

Ifinal1(:,:,1) =  Igt;
Ifinal1(:,:,2) =  Iresult;

figure;
subplot(1,3,1);
imshow(Igt);
subplot(1,3,2);
imshow(Iresult);
subplot(1,3,3);
imshow(Ifinal1);

figure;
imshow(Ifinal1);

H = fspecial('average',5);
filtered = imerode(Iresult,H,'replicate');

se = strel('disk',2);
erodedI = imerode(Iresult,se);

se = strel('disk',3);
erodedI = imdilate(erodedI,se);


Ifinal2 = zeros(f,c,3);
Ifinal2(:,:,1) =  Igt;
Ifinal2(:,:,2) =  erodedI;

figure;
subplot(1,2,1);
imshow(Iresult);
subplot(1,2,2);
imshow(erodedI);

figure;
subplot(1,3,1);
imshow(Igt);
subplot(1,3,2);
imshow(Ifinal1);
subplot(1,3,3);
imshow(Ifinal2);

end


