
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
            PathResul2='/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/GT/'; %ms

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


                % Carga imagenes

                Igt=imread(PathIMG3);
                Igt=imresize(Igt,[300 300]);

                Iraw=imread(PathResul);
                Iraw=imresize(Iraw,[300 300]);
                
               %Evaluacion Hoover
               

               
                [CD1,US1,OS1,M1,N1,regionesGT1,regionesMS1]=evalPerformance2(Igt,Iraw,t);

                
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
    
   % mandarCorreo('alexander.gomezv@udea.edu.co','qaviko73','Acabe  Belief con funcion 1 saturacion','Acabo','alviurlex@gmail.com');

catch theErrorInfo
    
  %  mandarCorreo('alexander.gomezv@udea.edu.co','qaviko73','Error en ejecucion',theErrorInfo.message,'alviurlex@gmail.com');
    
end
    