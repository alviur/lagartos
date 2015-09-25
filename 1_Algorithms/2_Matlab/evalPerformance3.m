%==========================================================================
% Function to eval Hoover metrics [1]
% Author: Alexander Gomez
%
%==========================================================================


% =============================Based on====================================
% [1] Hoover, Adam, Gillian Jean-Baptiste, Xiaoyi Jiang, Patrick J. Flynn, Horst
%Bunke, Dmitry B. Goldgof, Kevin Bowyer, David W. Eggert, Andrew Fitzgibbon,
% and Robert B. Fisher. "An experimental comparison of range image segmentation
% algorithms." Pattern Analysis and Machine Intelligence, IEEE Transactions on 18, 
% no. 7 (1996): 673-689.
%==========================================================================

%GT: Ground - Gold True
%MS: Machine Segmentation
%T: Tolerance
%CD: Correct Detection
%OS :Over-Segmentation
%US: Under-Segmentation
%M: Missed
%N: Noise


function [CD,US,OS,M,N,regionesGT,regionesMS]=evalPerformance3(GT,MS,T)

 %   GT=imread('/home/lex/Desktop/GT.png');
 %   MS=imread('/home/lex/Desktop/SEG2.png');
    

    
     %GT=imread('/home/lex/Desktop/SEG2.png');
    % MS=imread('/home/lex/Desktop/GT.png');
     
   %  imshow(MS)
    % waitforbuttonpress
    
    
    %GT=imread('/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/GT/ind1/DSCN1551.JPG');
   % MS=imread('/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/Resultados/ISVC/Original/Belief_1//ind1/DSCN1551.bmp');
   % T=0.7;
    
    
    % Correccion formato JPG
    A=find(GT>=100);
    B=find(GT<100);
    GT(A)=255;
    GT(B)=0;

    
   % imshow(GT)
   % waitforbuttonpress

    % Cambio a escala de grises si es necesario
    if(size(GT,3)>1)
        GT=rgb2gray(GT);
    end

    if(size(MS,3)>1)
       MS=rgb2gray(MS);
    end


    
    %MS=not(MS);% Solo para MS negativo
    
    MS=imresize(MS,[300 300]);
    GT=imresize(GT,[300 300]);
    
    % Etiquedato de imagenes de entrad
    LabelsGT = bwlabel(GT);
    LabelsMS = bwlabel(MS); 

    % Calculo de numero de regiones en cada imagen
    regionesGT=max(LabelsGT(:));
    regionesMS=max(LabelsMS(:));
    
    % Tablas
    tablaOnm=zeros(regionesGT,regionesMS,5);% Tabla Onm , las filas seran las regiones m y las columnas las de n
    tablaResul=zeros(regionesGT,regionesMS,5);
    
    tablaCD1=zeros(1,regionesGT);
    tablaCD2=zeros(1,regionesMS);
    tablaOS=zeros(1,regionesGT);
    tablaUS=zeros(1,regionesMS);
    
    %% Calculo de tabla Omn
    
     for n=1:regionesGT%% Por cada mancha en GT
           
         auxGT=(LabelsGT==n); % Toma la mancha n de GT  
         
        
        for m=1:regionesMS%% Por cada mancha en MS
            
            auxMS=(LabelsMS==m); % Toma la mancha M de MS            
            tablaOnm(n,m,1)=nnz((auxGT).*(auxMS)); % Realiza la interseccion entre regiones
            tablaOnm(n,m,2)=tablaOnm(n,m,1)/(nnz(auxGT)); % Porcentaje de interseccion que hay en la mancha GT
            tablaOnm(n,m,3)=tablaOnm(n,m,1)/(nnz(auxMS)); % Porcentaje de interseccion que hay en la mancha MS
            tablaOnm(n,m,4)=nnz(auxGT); % area mancha GT  
            tablaOnm(n,m,5)=nnz(auxMS); % area mancha MS 
            
        end
         
         
     end
    
    %% Reglas --------------------------------------
    
    %% Deteccion correcta CD
    
     for n=1:regionesGT%% Por cada mancha en GT
           
         
        
        for m=1:regionesMS%% Por cada mancha en MS
            
%              T
%             tablaOnm(n,m,2)
%             tablaOnm(n,m,3)
         
            if(tablaOnm(n,m,2)>=T )
                
                  
                if(tablaOnm(n,m,3)>=T)                    
                   
                    tablaCD1(1,n)=1;
                    tablaCD2(1,m)=1;
                    tablaResul(n,m,1)=1; % Marca las manchas como detecccion correcta
                    
                end
                
            end

            
        end
         
         
         
     end
    CD=sum(tablaCD1);
    
    %% Sobresegmentacion OS
    % se consideran sobresegmentadas solo las regiones en GT
    
     for n=1:regionesGT%% Por cada mancha en GT
    
        contadorRegiones=0; 
     
        for m=1:regionesMS%% Por cada mancha en MS
        
            if(tablaOnm(n,m,3)>T)
                
                contadorRegiones=contadorRegiones+1;                 
                
            end
            
            
            if(contadorRegiones>1  && tablaOnm(n,m,3)>T && tablaCD1(1,n)<1)% Deben ser 2 o mas regiones
                
                tablaResul(n,m,2)=1; % Marca las manchas como Sobresegmentadas  
                
                tablaResul(ant(1),ant(2),2)=1; % Marca las manchas como Sobresegmentada la primera
                
                tablaOS(1,n)=1;
               
                
            elseif(tablaOnm(n,m,3)>T)
                
                ant=[n,m,2];
                
            end

            
        end
       
        % Segunda condicion: sumatoria de regiones
        
        areaAcum=0;
        
        [x,y]=find(tablaResul(n,:,2));
        
        for i=1:sum(tablaResul(n,:,2))
            
            areaAcum=areaAcum + tablaOnm(x(i),y(i),1);
            
        end
        
        if(areaAcum<T) 
            
           for i=1:sum(tablaResul(n,:,2))
            
                tablaResul(x(i),y(i),2)=0;
            
           end
           
        
            
        end
          
         
     end    
     
     OS=sum(tablaOS);
    
 %% Subsegmentacion US
 % Se consideran subsegmentadas solo las regiones en MS
 
 
     for m=1:regionesMS%% Por cada mancha en GT
           
        contadorRegiones2=0; 
        
        for n=1:regionesGT%% Por cada mancha en MS
            
            if(tablaOnm(n,m,2)>T)
                
                contadorRegiones2=contadorRegiones2+1;                 
                
            end
            
            if(contadorRegiones2>1  && tablaOnm(n,m,2)>T && tablaCD2(1,m)<1)% Deben ser 2 o mas regiones
                
                tablaResul(n,m,3)=1; % Marca las manchas como Sobresegmentadas
                tablaResul(ant(1),ant(2),3)=1; % Marca las manchas como Sobresegmentada la primera
                tablaUS(1,m)=1;
                
            elseif(tablaOnm(n,m,1)>T)
                
                ant=[n,m,3];
                
            end

            
        end
        
        % Segunda condicion: sumatoria de regiones
        
        areaAcum=0;
        
        [x,y]=find(tablaResul(n,:,3));% ENcuentra todas las marcadas como US
        
        for i=1:sum(tablaResul(n,:,3))
            
            areaAcum=areaAcum + tablaOnm(x(i),y(i),1);% Suma las areas de todas
            
        end
        
        if(areaAcum<T) 
            
           for i=1:sum(tablaResul(n,:,3))
            
                tablaResul(x(i),y(i),3)=0;
            
           end
            
        end
         
     end    
     
     US=sum(tablaUS);
    
 %% MISSED
 % Solo son perdidas las regiones de GT
  
  
    M= sum(not(tablaCD1 + tablaOS));
 
    
    
    

 
 %% Noise
 % Solo son regiones de MS
 
 
     N= sum(not(tablaCD2 + tablaUS));
  
  
 
 
end
 