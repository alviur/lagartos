function Coordenadas=sacarManchas(I,numeroManchas)

    Coordenadas=zeros(numeroManchas,2);
    
    for i=1:numeroManchas

        image =imshow(I);
        waitforbuttonpress
        Coordenadas(i,:)=ImageClickCallback ( image , 'ButtonDownFcn' );
        
    end

end