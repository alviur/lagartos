%=====================================================
% Realiza preprocesamiento de la base de datos
%
%=====================================================

clear all, close all, clc


individuo0='ind';

for i=6:6
    
    i
    
    
    numeroToString = int2str(i);
    individuo=horzcat(individuo0,numeroToString,'/');
    
    % Paths a archivos
    PathIMG = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/Conjunto/';
    PathEXE = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/exe/preprocess';
    PathSaveCLAHE= ' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/Preprocesadas/CLAHE/';
    PathSavePosterizada= ' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/Preprocesadas/Posterizada/';
    PathSaveColor= ' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/Preprocesadas/Color/';
    extension='*.JPG';

    % Añade path del folder

    PathIMG2=horzcat(PathIMG,individuo);
    PathIMG=horzcat(PathIMG,individuo);
    PathSaveCLAHE=horzcat(PathSaveCLAHE,individuo);
    PathSavePosterizada=horzcat(PathSavePosterizada,individuo);
    PathSaveColor=horzcat(PathSaveColor,individuo);

    %Extrae cantidad de archivos en folder
    archives=dir(horzcat(PathIMG,extension));

    for i=1:size(archives)

       % Navega por cada archivo

       PathIMG3=horzcat(PathIMG2,archives(i).name);
       PathSaveCLAHE2=horzcat(PathSaveCLAHE,archives(i).name);
       PathSavePosterizada2=horzcat(PathSavePosterizada,archives(i).name);
       PathSaveColor2=horzcat(PathSaveColor,archives(i).name);


       % Carga imagenes

        I=imread(PathIMG3);
        PathIMG3

     imshow(I)
     waitforbuttonpress

        % Ejecuta programa en consola

        PathEXE2= horzcat(PathEXE,' ',PathIMG3, PathSaveCLAHE2,PathSavePosterizada2,PathSaveColor2)
        s = system(PathEXE2);


    end


end