clc 
clear all
close all

raw = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/Ground/';
gt = '/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/true/';
numImages=20;

for i=1:numImages;
    
    %% Preprocesamiento
    numeroToString = int2str(i);
    fileName = strcat(raw,numeroToString);

    fileNameCLAHE = horzcat(' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/2_Matlab/CLAHE/',numeroToString,'.jpg');
    fileNamePOST = horzcat(' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/2_Matlab/POSTERIZADA/',numeroToString,'.jpg');
    fileNameColorMask = horzcat(' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/2_Matlab/CLAHE/gimp/',numeroToString,'.jpg ');
    fileNameToConsole=horzcat('./preprocesamientoDB ',fileName,fileNameCLAHE,fileNamePOST,fileNameColorMask);
    I1 = imread(fileName);
    s = system(fileNameToConsole);

    
    %% Evaluacion MRF
    
    fileNameResult=horzcat('/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/2_Matlab/Resultados/',numeroToString,'.jpg');
    fileNameToConsoleMRF=horzcat('./Segmentation_RGB ',fileName,fileNameColorMask,fileNameResult);
    s2 = system(fileNameToConsoleMRF);
      

    
%     %% Validacion de Resultado
% 
%     fileNameGT = horzcat(gt,numeroToString,'.jpg');
%     Igt = imread(fileNameGT);
%     Iresult = imread(fileNameResult);
%     
%     Ifinal2=evalSegment(Igt,Iresult);
%     
%     imshow(Ifinal2);
%     title('Resultado a guardar')
%     
%     waitforbuttonpress
    
end



