%=====================================================
% Extrae conjunto de escamas
%
%=====================================================

clear all, close all, clc

% Paths a archivos
PathMS = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/Segmentado/ind6/';
PathGT = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/sin_segmentar/ind6/';
PathSave= '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/Conjunto/ind6/';
extension='*.JPG';

archives=dir(horzcat(PathMS,extension));

for i=1:size(archives)

   % Navega por cada archivo
   PathMS2 =horzcat(PathMS,archives(i).name);
   PathGT2 =horzcat(PathGT,archives(i).name);
   PathSave2 =horzcat(PathSave,archives(i).name);
   
   % Carga imagenes
 
   
    I=imread(PathMS2);
    Ioriginal=imread(PathGT2);
    
 %imshow(I)
 %waitforbuttonpress
    
     I=imresize(I,[size(Ioriginal,1) size(Ioriginal,2)]);% El programa del ipad cambia tamaño
    size(I)
    size(Ioriginal)
    
    % Extrae escama encerrada en Rojo
    extraida=extraerConjuntoEscamas(I,Ioriginal);
    
    imwrite(extraida,PathSave2);% Guarda imagen
    
    
end