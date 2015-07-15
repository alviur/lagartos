clc 
clear all
close all


numImages=20;

maxUmbral=9;
maxPeso=9;
iteraciones=[5 10 15 20 25 30 35 40];
maxfunciones=2;

for i=1:numImages;
    
    numeroToString = int2str(i);
    fileNameCLAHE = horzcat(' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/2_Matlab/CLAHE/',numeroToString,'.jpg');
    fileNamePOST = horzcat(' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/2_Matlab/POSTERIZADA/',numeroToString,'.jpg');
    fileNameResul= horzcat(' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/2_Matlab/',numeroToString);

    
    for f=0:maxfunciones%Por cada funcion
        for u=0:1:maxUmbral
            for p=0:maxPeso
                
                for ite=1:size(iteraciones,2)
                    
                    fileNameResul= horzcat(' /home/lex/2_SISTEMIC/3_MRF/1_Lagartos/1_Algorithms/2_Matlab/',numeroToString);
                    fileNameResul= horzcat(fileNameResul,'_',int2str(0),'_',int2str(f),'_',int2str(u),'_',int2str(p),'_',int2str(iteraciones(ite)),'.jpg');
                    
                    fileNameToConsole=horzcat('./mrflagartos ',fileNameCLAHE,fileNamePOST,fileNameResul);
                    fileNameToConsole=horzcat(fileNameToConsole,' ',int2str(0),' ',int2str(f),' ',int2str(u),' ',int2str(p),' ',int2str(iteraciones(ite)));
                    %s = system(fileNameToConsole);
                    fileNameToConsole
                    waitforbuttonpress
                    
                end
            end
            
        end  
        
        
        
    end    
    
    
end