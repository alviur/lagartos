%=============================================
%
%
%=============================================

%function extraerEscamasSuperior(I,Ioriginal)


I=imread('/home/lex/Desktop/IMG_0294.JPG');
Ioriginal=imread('/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/sin_segmentar/ind11/DSCN1776.JPG');

I=imresize(I,[3672 4896]);





   % ISegmented = I(:,:,1);%Separa canal rojo
    ISegmented = I;%Separa canal rojo


    %% Preprocesamiento
    
      
    nueva=zeros(size(ISegmented,1),size(ISegmented,2));
    nueva(find(ISegmented(:,:,1)>230 & ISegmented(:,:,2)<100))=255;
    
    se = strel('disk',4,4);%elemento estructurante
    nueva = imdilate(nueva,se);%dilatacion
    
    BW4 = im2bw(nueva);    
    BW4=imresize(BW4,[3672 4896]);
    binaryImage = imfill(BW4,'holes'); % Llena agujeros del contorno
    
    %Ioriginal=Ioriginal(:,:,:).*uint8(not(binaryImage));
    
     binaryImage=imresize(binaryImage,[3672 4896]);
    
  
    Inew = Ioriginal.*repmat(uint8((binaryImage)),[1,1,3]);% Aplica la mascara a los 3 canales
     

    
    %Rectangle = regionprops(binaryImage, 'BoundingBox');%Obtiene bounding box        
    %recortada = imcrop(Inew,Rectangle.BoundingBox);%Recorta imagen
    
    escamasInd=and( (not(BW4)),(binaryImage));    
    
    
    
    escamasInd = imfill(escamasInd,'holes'); % Llena agujeros del contorno
    
    


    EscamasLabel = bwlabel(escamasInd);% Asigna una etiqueta a cada mancha

    boundaries = bwboundaries(binaryImage); % Get list of (x,y) coordinates of outer perimeter.
    
    

    %% Seleccion de Escamas

    
    %%%%%PA1
    
    for i=1:max(max(EscamasLabel))
        
            PA1= I.*repmat(uint8(((EscamasLabel==i))),[1,1,3]);% Aplica la mascara a los 3 canales
            PA1a=zeros(size(ISegmented,1),size(ISegmented,2));
            PA1a(find(PA1(:,:,1)>230 & PA1(:,:,3)<10 & PA1(:,:,2)<10) )=255;% Busca por el color de cada escama
            n=nnz(PA1a);% Encuentra elementos que no son cero
            
            if(n>20)
                
                 Rectangle = regionprops((EscamasLabel==i), 'BoundingBox');%Obtiene bounding box        
                 recortadaPA1 = imcrop(Ioriginal.*repmat(uint8((EscamasLabel==i)),[1,1,3]),Rectangle.BoundingBox);%Recorta imagen
            end
     

        
        
    end
    
  
                
    %%%%%%PA2
    
    for i=1:max(max(EscamasLabel))
        
            PA2= I.*repmat(uint8(((EscamasLabel==i))),[1,1,3]);% Aplica la mascara a los 3 canales
            PA2a=zeros(size(ISegmented,1),size(ISegmented,2));
            PA2a(find(PA2(:,:,1)<100 & PA2(:,:,3)<10 & PA2(:,:,2)>230) )=255;% Busca por el color de cada escama
            n=nnz(PA2a);% Encuentra elementos que no son cero
            
            if(n>20)
                
                 Rectangle = regionprops((EscamasLabel==i), 'BoundingBox');%Obtiene bounding box        
                 recortadaPA2 = imcrop(Ioriginal.*repmat(uint8((EscamasLabel==i)),[1,1,3]),Rectangle.BoundingBox);%Recorta imagen
            end
     

        
        
    end
    
                
    %%%%%%IP
    
    for i=1:max(max(EscamasLabel))
        
            IP= I.*repmat(uint8(((EscamasLabel==i))),[1,1,3]);% Aplica la mascara a los 3 canales
            IPa=zeros(size(ISegmented,1),size(ISegmented,2));
            IPa(find(IP(:,:,1)<100 & IP(:,:,3)>250 & IP(:,:,2)<100) )=255;% Busca por el color de cada escama
            n=nnz(IPa);% Encuentra elementos que no son cero
            
            if(n>20)
                
                 Rectangle = regionprops((EscamasLabel==i), 'BoundingBox');%Obtiene bounding box        
                 recortadaIP = imcrop(Ioriginal.*repmat(uint8((EscamasLabel==i)),[1,1,3]),Rectangle.BoundingBox);%Recorta imagen
            end
     

        
        
    end    
    
        %%%%%%FP1
    
    for i=1:max(max(EscamasLabel))
        
            FP1= I.*repmat(uint8(((EscamasLabel==i))),[1,1,3]);% Aplica la mascara a los 3 canales
            FP1a=zeros(size(ISegmented,1),size(ISegmented,2));
            FP1a(find(FP1(:,:,1)>230 & FP1(:,:,3)<10 & FP1(:,:,2)>230) )=255;% Busca por el color de cada escama
            n=nnz(FP1a);% Encuentra elementos que no son cero
            
            if(n>20)
                
                 Rectangle = regionprops((EscamasLabel==i), 'BoundingBox');%Obtiene bounding box        
                 recortadaFP1 = imcrop(Ioriginal.*repmat(uint8((EscamasLabel==i)),[1,1,3]),Rectangle.BoundingBox);%Recorta imagen
            end
     

        
        
    end    
    
    %%%%%%FP2
    
    for i=1:max(max(EscamasLabel))
        
            FP2= I.*repmat(uint8(((EscamasLabel==i))),[1,1,3]);% Aplica la mascara a los 3 canales
            FP2a=zeros(size(ISegmented,1),size(ISegmented,2));
            FP2a(find(FP2(:,:,1)>230 & FP2(:,:,3)>250 & FP2(:,:,2)<10) )=255;% Busca por el color de cada escama
            n=nnz(FP2a);% Encuentra elementos que no son cero
            
            if(n>20)
                
                 Rectangle = regionprops((EscamasLabel==i), 'BoundingBox');%Obtiene bounding box        
                 recortadaFP2 = imcrop(Ioriginal.*repmat(uint8((EscamasLabel==i)),[1,1,3]),Rectangle.BoundingBox);%Recorta imagen
            end
     

        
        
    end    
    
    %%%%%%FR
    
    for i=1:max(max(EscamasLabel))
        
            FR= I.*repmat(uint8(((EscamasLabel==i))),[1,1,3]);% Aplica la mascara a los 3 canales
            FRa=zeros(size(ISegmented,1),size(ISegmented,2));
            FRa(find(FR(:,:,1)<10 & FR(:,:,3)>250 & FR(:,:,2)>230) )=255;% Busca por el color de cada escama
            n=nnz(FRa);% Encuentra elementos que no son cero
            
            if(n>20)
                
                 Rectangle = regionprops((EscamasLabel==i), 'BoundingBox');%Obtiene bounding box        
                 recortadaFR = imcrop(Ioriginal.*repmat(uint8((EscamasLabel==i)),[1,1,3]),Rectangle.BoundingBox);%Recorta imagen
            end
     

        
        
    end       
    
                imshow(recortadaFP1)   
                waitforbuttonpress
                
                imshow(recortadaFP2)   
                waitforbuttonpress
                
                imshow(recortadaFR)   
                waitforbuttonpress
                
                imshow(recortadaPA1)   
                waitforbuttonpress
                
                imshow(recortadaPA2)   
                waitforbuttonpress
                
                
    
    
%     ISegmentedFR = I(:,:,2);%Separa canal Azul para FR
%     ISegmentedFR=ISegmentedFR(ISegmentedFR>250);%Binariza dejando solo rojo mas intenso
%     ISegmentedFR= logical(ISegmentedFR);
%     [row,cols]=find(ISegmentedFR.*EscamasLabel>0);
%     row
%     cols
%     indiceFR=EscamasLabel(row(1),cols(1));
%     
%        
%     Rectangle = regionprops(EscamasLabel(EscamasLabel==indiceFR), 'BoundingBox');%Obtiene bounding box
%        
%     recortada = imcrop(I,Rectangle);%Recorta imagen
%     
%     imshow(recortada)
%     waitforbuttonpress
%     
%     %FR
%     ISegmentedFR = I(:,:,2);%Separa canal Azul para FR
%     ISegmentedFR=ISegmentedFR(ISegmentedFR>250);%Binariza dejando solo rojo mas intenso
%     ISegmentedFR= logical(ISegmentedFR);
%     [row,cols]=find(ISegmentedFR.*EscamasLabel>0);
%     indiceFR=EscamasLabel(row(1),cols(1));

%end