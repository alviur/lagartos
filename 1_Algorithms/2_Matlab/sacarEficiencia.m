







%%%%% Evaluacion


Tverdaderos=0;
Ffalsos=0;
numImages=93;


for i=1:numImages
    

      if(i~=19 && i~=20)
          
        confusionMatrix{i}(isnan(confusionMatrix{i}))=0;
        %N(isnan(N))=0;
        Tverdaderos=Tverdaderos+confusionMatrix{i}(1,1);
        Ffalsos=Ffalsos+confusionMatrix{i}(2,2);
        i
                
      end

  
    
    
end


Tverdaderos=Tverdaderos/(numImages);
Ffalsos=Ffalsos/(numImages);

confianza=(Tverdaderos+Ffalsos)/2

