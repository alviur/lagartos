clear all, close all, clc;
mkdir('imagesResultadosColor');

for(i=1:20)
    
    mancha = int2str(i);
    fileNameGT = strcat('imagesLogicalGT\',mancha,'.png');
    fileNameSeg = strcat('imagesSegmented\',mancha,'.png');
    IGT = imread(fileNameGT);
    ISeg = imread(fileNameSeg);
    [f,c] = size(IGT);
    IColor = zeros(f,c,3);
    IColor(:,:,1) =  IGT;
    IColor(:,:,2) =  ISeg;
    fileNameSave = strcat('imagesResultadosColor\',mancha,'.png');
    imwrite(IColor,fileNameSave);
    
end