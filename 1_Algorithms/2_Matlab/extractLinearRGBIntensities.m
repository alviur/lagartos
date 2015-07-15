%%%%%%%%%%%%%%%%%%%%
% Devuelve las intensidades RGB en vectores de 1 fila
%
%
%%%%%%%%%%%%%%%%%%%%



function out=extractLinearRGBIntensities(I) 

    out=zeros(3,size(I,1)*size(I,2));

    out(1,:)=reshape(I(:,:,1)',size(I,1)*size(I,2),1);
    out(2,:)=reshape(I(:,:,2)',size(I,1)*size(I,2),1);
    out(3,:)=reshape(I(:,:,3)',size(I,1)*size(I,2),1);
    
   


end