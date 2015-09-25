
try

   % clear all, close all, clc

    
   contador=1;
   individuo0='ind';
   confusionMatrix=cell(95,1);
   confusion=zeros(95,1);

    for j=1:20
j
        if(j~=6)
            numeroToString = int2str(j);
            individuo=horzcat(individuo0,numeroToString,'/');

            % Paths a archivos
            PathIMG = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/GT/';%Ground true
            PathResul2='/home/lex/Desktop/active/2/Original/PushRelabel_3/';% Segementado 

            extension='*.JPG';

            % Añade path del folder

            PathIMG2=horzcat(PathIMG,individuo);
            PathResul3=horzcat(PathResul2,individuo);


            %Extrae cantidad de archivos en folder
            archives=dir(horzcat(PathIMG2,extension));
            horzcat(PathIMG2,extension)



            for i=1:size(archives)




                % Navega por cada archivo

                PathIMG3=horzcat(PathIMG2,archives(i).name);
                PathResul=horzcat(PathResul3,archives(i).name);


                % Carga imagenes

                Igt=imread(PathIMG3);
                
                % Correccion formato JPG
                A=find(Igt>=100);
                B=find(Igt<100);
                Igt(A)=255;
                Igt(B)=0;
                



                PathResul=PathResul(1:end-4);
                PathResul=horzcat(PathResul,'.bmp')





                Iraw=imread(PathResul);
                Iraw=imresize(Iraw,[300 300]);

 

               % Evalua matriz de confusion

                Igt=imresize(Igt,[300 300]);
                Igt(Igt(:,:,:)<250)=0;
                Igt2=Igt(:,:,1);               

               % Iraw=not(Iraw);
% 
% 
%                 imshow(Igt2);
%                 figure
%                 imshow(Iraw);
%                 waitforbuttonpress

                Igt2 = logical(Igt2);

                Iraw = logical(Iraw);
                [x y] = size(Iraw);

                vectorImageGT = reshape(Igt2,x*y,1);
                vectorEscamaSegmentada = reshape(Iraw,x*y,1);




                CM = confusionmat(vectorImageGT,vectorEscamaSegmentada);
                CMNor = zeros(2,2);
                CMNor(:,1) = CM(:,1)/(CM(1,1)+CM(2,1));
                CMNor(:,2) = CM(:,2)/(CM(1,2)+CM(2,2));
                %CMNor = CM/(x*y);                 



                confusionMatrix{contador,1}=CMNor;

                confusion(contador,1)=(CMNor(1,1)+CMNor(2,2))/2;



                contador=contador+1;    





            end
        end
        
    end
    
   % mandarCorreo('alexander.gomezv@udea.edu.co','pass','Acabe  Belief con funcion 1 saturacion','Acabo','alviurlex@gmail.com');

   media=median(confusion)
   desviacion=std(confusion)
   
   
catch theErrorInfo
    
  %  mandarCorreo('alexander.gomezv@udea.edu.co','pass','Error en ejecucion',theErrorInfo.message,'alviurlex@gmail.com');
    
end
    