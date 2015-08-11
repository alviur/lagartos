function recortada=extraerConjuntoEscamas(I,Ioriginal)



 %I=imresize(I,[3672 2048]);% El programa del ipad cambia tamaño


   % ISegmented = I(:,:,1);%Separa canal rojo
    ISegmented = I;%Separa canal rojo


    %% Preprocesamiento
    
      
    nueva=zeros(size(ISegmented,1),size(ISegmented,2));
    nueva(find(ISegmented(:,:,1)>230 & ISegmented(:,:,2)<100))=255;
    
    se = strel('disk',4,4);%elemento estructurante
    nueva = imdilate(nueva,se);%dilatacion
    
    BW4 = im2bw(nueva);    
    binaryImage = imfill(BW4,'holes'); % Llena agujeros del contorno
    
    
  
    Inew = Ioriginal.*repmat(uint8((binaryImage)),[1,1,3]);% Aplica la mascara a los 3 canales
     

    
    Rectangle = regionprops(binaryImage, 'BoundingBox');%Obtiene bounding box 
       
    recortada = imcrop(Inew,Rectangle.BoundingBox);%Recorta imagen
        

  

end