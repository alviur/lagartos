%==========================================================================
%
%
%==========================================================================

CD=zeros(1,6);
US=zeros(1,6);
OS=zeros(1,6);
M=zeros(1,6);
N=zeros(1,6);
regionesGT=zeros(1,6);
regionesMS=zeros(1,6);
umbral=1;


GT=imread('/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/GT/ind1/DSCN1551.JPG');
MS=imread('/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/Resultados/ISVC/Saturacion/Belief1/ind1/DSCN1551.bmp');

% Correccion formato JPG
A=find(GT>=100);
B=find(GT<100);
GT(A)=255;
GT(B)=0;


MS=imresize(MS,[300 300]);
GT=imresize(GT,[300 300]);
% Dilate
%se = strel('line',10,10);
%MS = imdilate(MS,se);


for i=0.1:0.1:1

    [CD1,US1,OS1,M1,N1,regionesGT1,regionesMS1]=evalPerformance3(GT,MS,i);
    
    CD(1,umbral)=CD1;
    US(1,umbral)=US1;
    OS(1,umbral)=OS1;
    M(1,umbral)=M1;
    N(1,umbral)=N1;
    regionesGT(1,umbral)=regionesGT1;
    regionesMS(1,umbral)=regionesMS1;
    umbral=umbral+1;

end


%% Graficas

graficarHoover(CD,OS,US,M,N,regionesGT,regionesMS)
figure
GT=rgb2gray(GT);
colored=colorImage(GT,MS);
imshow(colored)
