
try

   % clear all, close all, clc

    
   contador=1;
   individuo0='ind';

   
   CD=zeros(95,6);
   US=zeros(95,6);
   OS=zeros(95,6);
   M=zeros(95,6);
   N=zeros(95,6);
   regionesGT=zeros(95,6);
   regionesMS=zeros(95,6);
   umbral=1;

for t=0.1:0.1:1  
    t
    contador=1;
   individuo0='ind';
   
    for j=1:20
        
        if(j~=6)
            numeroToString = int2str(j);
            individuo=horzcat(individuo0,numeroToString,'/');

            % Paths a archivos
            PathIMG = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/GT/';%GT
            PathResul2='/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/thresh/local/threshold_48/';%MS 

            extension='*.JPG';

            % Añade path del folder

            PathIMG2=horzcat(PathIMG,individuo);
            PathResul3=horzcat(PathResul2,individuo);


            %Extrae cantidad de archivos en folder
            archives=dir(horzcat(PathIMG2,extension));
            %horzcat(PathIMG2,extension)



            for i=1:size(archives)

                % Navega por cada archivo

                PathIMG3=horzcat(PathIMG2,archives(i).name);
                PathResul=horzcat(PathResul3,archives(i).name);
                
                
                PathResul = PathResul(1:end-4);
                %PathResul=horzcat(PathResul,'.bmp');


                % Carga imagenes

                Igt=imread(PathIMG3);
  
                % Correccion formato JPG
                A=find(Igt>=100);
                B=find(Igt<100);
                Igt(A)=255;
                Igt(B)=0;


                
                Igt=imresize(Igt,[300 300]);

                Iraw=imread(PathResul);
                Iraw=imresize(Iraw,[300 300]);
                
                
                %imshow(Iraw)
                %waitforbuttonpress
                
               %Evaluacion Hoover
               

               
                [CD1,US1,OS1,M1,N1,regionesGT1,regionesMS1]=evalPerformance3(Igt,Iraw,t);

                
                   CD(contador,umbral)=CD1;
                   US(contador,umbral)=US1;
                   OS(contador,umbral)=OS1;
                   M(contador,umbral)=M1;
                   N(contador,umbral)=N1;
                  regionesGT(contador,umbral)=regionesGT1;
                   regionesMS(contador,umbral)=regionesMS1;


                 contador=contador+1;   

                 

            end
        end
        
    end
    
     umbral=umbral+1;
    
end


% %% Graficas
% 
% 
% mCD=median(CD);
% mUS=median(US);
% mOS=median(OS);
% mM=median(M);
% mN=median(N);
% 
% 
% subplot(3,2,1)
% %CD
% plot(CD)
% title('Correct detection')
% hold on
% subplot(3,2,2)
% plot(US,'--','Color',[1,0,0])
% title('Under Segmentation')
% hold on
% subplot(3,2,3)
% plot(OS,'--','Color',[1,1,0])
% title('Over segmentation')
% hold on
% subplot(3,2,4)
% plot(M,'--','Color',[1,0,1])
% title('Missed')
% hold on
% subplot(3,2,5)
% plot(N,'--','Color',[0,1,1])
% title('Noise')
% grid on
% 
% legend('CD','US','OS','M','N')
% hold off
    
   % mandarCorreo('alexander.gomezv@udea.edu.co','qaviko73','Acabe  Belief con funcion 1 saturacion','Acabo','alviurlex@gmail.com');

catch theErrorInfo
    
  %  mandarCorreo('alexander.gomezv@udea.edu.co','qaviko73','Error en ejecucion',theErrorInfo.message,'alviurlex@gmail.com');
    
end
    