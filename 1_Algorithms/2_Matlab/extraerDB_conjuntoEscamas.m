%=====================================================
% Extrae conjunto de escamas
%
%=====================================================

clear all, close all, clc

% Paths a archivos
PathMS = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/Segmentado/ind14/';
PathGT = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/Segmentado_manchas/ind14/';
PathSave= '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/GT/ind14/';
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
    
 
 

 
     Ioriginal=imresize(Ioriginal,[3672 4896 ]);% El programa del ipad cambia tamaño
      
      
     I=imresize(I,[size(Ioriginal,1) size(Ioriginal,2)]);% El programa del ipad cambia tamaño
 size(Ioriginal)
    
    % Extrae escama encerrada en Rojo
    nueva=zeros(size(Ioriginal,1),size(Ioriginal,2));
    nueva(find(Ioriginal(:,:,1)>230 & Ioriginal(:,:,2)<100))=255;
    nueva = imfill(nueva,'holes');
    
    Ioriginal = Ioriginal.*repmat(uint8((nueva)),[1,1,3]);% Aplica la mascara a los 3 canales
    Ioriginal(:,:,1) = nueva;
    Ioriginal(:,:,2) = nueva;
    Ioriginal(:,:,3) = nueva;
     
    size(Ioriginal)

    extraida=extraerConjuntoEscamas(I,Ioriginal);
    
    %imshow(extraida);
   % waitforbuttonpress
    
    imwrite(extraida,PathSave2);% Guarda imagen
    
    
end