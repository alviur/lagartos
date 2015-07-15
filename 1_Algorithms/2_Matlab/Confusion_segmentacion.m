clear all, close all, clc

%inicioUno = '/home/lex/2_SISTEMIC/1_Proyecto_Microalgas/2_Database/Algas_segmentadas/1SEQGRAY/';
inicioUnoMaskraw = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/2_Matlab/mascaraColorGimp/';
inicioUnoMasktrue = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/true/';
numImages=20;


for(i=1:numImages)
    i
   
    numeroToString = int2str(i);
    %fileName = strcat(inicioUno,numeroToString,'.bmp');
    fileNameMaskRaw = strcat(inicioUnoMaskraw,'Color_mask',numeroToString,'.jpg');
    fileNameMaskTrue = strcat(inicioUnoMasktrue,numeroToString,'.jpg');
   
    
    
    Igt=imread(fileNameMaskTrue);
    Iraw=imread(fileNameMaskRaw);
    
    Iraw=imresize(Iraw,[500 500]);
    Igt=imresize(Igt,[500 500]);
    Igt(Igt(:,:,:)<250)=0;
    Igt2=Igt(:,:,1);
    Iraw=Iraw(:,:,1);
    
    
    
    
    %% MANCHAS IDENTIFICADAS COMO MANCHAS
    Iand = and(Igt2,Iraw);
    disp('Verdaderos Positivos')
    nWhite = nnz(Iand)
   
    
    %% FONDO IDENTIFICADO COMO FONDO
     Ior = or(Igt2,Iraw);
     Ior=not(Ior);
    disp('Verdaderos Negativos')
    nWhite = nnz(Ior)
    
    
    %% FONDO IDENTIFICADO COMO MANCHA
    Ifm=and(not(Igt2),Iraw);
    disp('Falsos positivos')
    nWhite = nnz(Ifm)
    
    
    %% MANCHA IDENTIFICADA COMO FONDO
        
    Imf=and((Igt2),not(Iraw));
    
    disp('Falsos Negativos')
    nWhite = nnz(Imf)
 
    

    
     %Ifinal1=evalSegment(Iraw,Igt);
     
    % imshow(Ifinal1);
     waitforbuttonpress
    
    
    
    
    
end