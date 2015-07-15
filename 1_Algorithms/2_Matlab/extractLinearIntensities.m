%%%%%%%%%%%%%%%%%%%%
% Devuelve las intensidades  en vectores de 1 fila
%
%
%%%%%%%%%%%%%%%%%%%%



function intensidad=extractLinearIntensities(I) 

    intensidad=reshape(I',size(I,1)*size(I,2),1);
    intensidad=intensidad';
   
end