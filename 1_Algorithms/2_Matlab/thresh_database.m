%=====================================================
% Extrae conjunto de escamas
%
%=====================================================

clear all, close all, clc

% Paths a archivos
PathMS1 = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/Correccion_saturacion/ind';
PathSave1= '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/threshold/ind';
extension='*.JPG';


for l=1:20
    l
    
    PathMS =horzcat(PathMS1,num2str(l),'/');
    PathSave=horzcat(PathSave1,num2str(l),'/');
    
    archives=dir(horzcat(PathMS,extension));

    for i=1:size(archives)

       % Navega por cada archivo
       PathMS2 =horzcat(PathMS,archives(i).name);
       PathSave2 =horzcat(PathSave,archives(i).name);

       % Carga imagenes


        I=imread(PathMS2);
        I=rgb2gray(I);

       BW=adaptivethreshold(I,39,0.01,0);
      %  BW = im2bw(I,graythresh(I));%otsu
        
       %    BW = im2bw(I,0.8);%otsu

     %imshow(BW)
     %waitforbuttonpress
        
     PathSave2=PathSave2(1:end-4);

      imwrite(BW,PathSave2,'bmp');% Guarda imagen


    end

end