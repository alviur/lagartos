%=====================================================
% Procesa base de datos con algoritmo MRF
%
%=====================================================

clear all, close all, clc

   
inferencia=' 0';%Tipo de algoritmo de inferencia
funcion=' 0';%Funcion de energia a usar
umbral=' 5';%umbral para funcion de smooth
peso=' 9';%Peso para funcion de Smooth
iteraciones=' 30';%Solo loopy belief propagation

individuo0='ind';

for i=1:20
    
    i
    
    
    numeroToString = int2str(i);
    individuo=horzcat(individuo0,numeroToString,'/');
    
    % Paths a archivos
    PathIMG = ' /media/pds/03D78A9C4FE834AF/Lagartos_lex/Lagartos/ISCV/Database/';
    PathResul2= ' /media/pds/03D78A9C4FE834AF/Lagartos_lex/Lagartos/ISCV/Resultados/'; 
    PathColo2r= '/media/pds/03D78A9C4FE834AF/Lagartos_lex/Lagartos/ISCV/Database/saturacion/';                                                                                                                                      
    PathEXE = '/media/pds/03D78A9C4FE834AF/Lagartos_lex/Lagartos/mrflagartos';
    extension='*.JPG';

    % Añade path del folder

    PathIMG2=horzcat(PathIMG,individuo);
    PathResul3=horzcat(PathResul2,individuo);
    PathColor=horzcat(PathColor2,individuo);


    %Extrae cantidad de archivos en folder
    archives=dir(horzcat(PathIMG,extension));

    for i=1:size(archives)

       % Navega por cada archivo

       PathIMG3=horzcat(PathIMG2,archives(i).name);
       PathResul=horzcat(PathResul3,archives(i).name);
  


       % Carga imagenes

        I=imread(PathIMG3);
        PathIMG3

     imshow(I)
     waitforbuttonpress

        % Ejecuta programa en consola

        PathEXE2= horzcat(PathEXE,' ',PathIMG3, PathColor,PathResul,inferencia,funcion,umbral,peso,iteraciones)
        s = system(PathEXE2);


    end


end