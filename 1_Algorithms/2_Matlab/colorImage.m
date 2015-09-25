%==========================================================================
% Function: colorImage
% Author: Alexander Gomez
%
%==========================================================================

%Eval segmentation returning a colored image where yellow means correct
% segmentation, red under-segmentation, green noise


% IGT: Ground true - gold true
% ISeg: Machine segmentation
% colored: color image

function colored=colorImage(IGT,ISeg)

  

    [f,c] = size(IGT);
    IColor = zeros(f,c,3);
    IColor(:,:,1) =  IGT;
    IColor(:,:,2) =  ISeg;    
    colored=IColor;    

end



%/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/2_Dataset/GT/ind1/DSCN1551.JPG

%/home/lex/Desktop/Metricas_segmentacion/Saturacion/Belief_3/ind1/DSCN1551.bmp