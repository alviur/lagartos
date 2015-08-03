%================================
% 
%
%
%================================


% ===================================Based on==========================================
% Hoover, Adam, Gillian Jean-Baptiste, Xiaoyi Jiang, Patrick J. Flynn, Horst Bunke,
% Dmitry B. Goldgof, Kevin Bowyer, David W. Eggert, Andrew Fitzgibbon,
% and Robert B. Fisher. "An experimental comparison of range image segmentation
% algorithms." Pattern Analysis and Machine Intelligence, IEEE Transactions on 18, 
% no. 7 (1996): 673-689.
%=======================================================================================

%GT: Ground True
%MS: Machine Segmentation
%T: Tolerance
%CD: Correct Detection
%OS :Over-Segmentation
%US: Under-Segmentation
%M: Missed
%N: Noise


%function [CD,US,OS,M,N]=evalPerformance2(GT,MS,T)


GT=imread('GT.png');
MS=imread('SEG2.png');

GT=rgb2gray(GT);
MS=rgb2gray(MS);

T=0.2;

    % Inicialization

        CD=0;
        OS=0;
        US=0;
        M=0;
        N=0;

        
        flagMS=0;
        flagGT=0;
      flagM=0;
         


    %Label each image region

        LabelsGT = bwlabel(GT);
        LabelsMS = bwlabel(MS);   

       interception=and(GT,MS);%interception
       LabelsInter = bwlabel(interception);

    % Para missed
    StatesM=zeros(3,max(LabelsMS(:)));
    StatesN=zeros(3,max(LabelsGT(:)));
    
    
    %% Correct Detection

    for i=1:max(LabelsInter(:))%% Por cada mancha en la intercepcion entre GT y MS
        
        interceptionInd=(LabelsInter==i);
        
    
           intermedioGT=(LabelsGT).*(interceptionInd); 
           intermedioMS=(LabelsMS).*(interceptionInd);    
                     
        
          
           %===============================================================
           % Busca todos los labels con los que se intercepto el
           % Machine-segmentation
               
           
         interGT=intermedioGT>0;
         
         inter2GT=intermedioGT(interGT);
         
         for j=1:max(LabelsGT(:))
             
             if(find(inter2GT==j))
                 
                 intermedioGTEval=intermedioGT(intermedioGT==j);
                 M = nnz(intermedioGTEval);%Count non-zero elements
                 if(M>=T*nnz(GT(LabelsGT==j))) 
                     
                     flagGT=1;
                     StatesN(1,j)=1;
                 
                 end 
                 
             end    
             
             
         end
           
           %===============================================================
           % Busca todos los labels con los que se intercepto el
           % Machine-segmentation
               
           
         interMS=intermedioMS>0;
         
         inter2MS=intermedioMS(interMS);
         
         for j=1:max(LabelsMS(:))
             
             if(find(inter2MS==j))
                 
                 intermedioMSEval=intermedioMS(intermedioMS==j);
                 M = nnz(intermedioMSEval);%Count non-zero elements
                 if(M>=T*nnz(MS(LabelsMS==j)) &&  flagGT==1 && flagMS==0)
                     
                     flagMS=1;
                     CD=CD+1;
                     StatesM(1,j)=1;
                     
                     
                 else
                     
                 
                 end 
                 
             end    
             
             
         end
           
           imshow(intermedioGT)
           waitforbuttonpress

    

            flagMS=0;
            flagGT=0;

    end


    %% Over- segmentation
    % Se consideran sobresegmentadas solo las regiones del GT
    
    for i=1:max(LabelsGT(:))%% Por cada mancha en la intercepcion entre GT y MS
    
        
        % primera condicion
        
        interceptionInd=(LabelsGT==i);
        
        intermedioMS=(LabelsMS).*(interceptionInd);  
                
        interMS=intermedioMS>0;
         
         inter2MS=intermedioMS(interMS);
         
         for j=1:max(LabelsMS(:))
             
             if(find(inter2MS==j))
                 
                 intermedioMSEval=intermedioMS(intermedioMS==j);
                 M = nnz(intermedioMSEval);%Count non-zero elements
                 
                 if(M>=T*nnz(MS(LabelsMS==j)) &&   StatesN(1,i)~=1)
                     
                     flagMS=1;
                                         
                 
                 end 
                 
             end    
             
             
         end
         
         % Segunda condicion
         
        M=nnz( intermedioMS);
        if(M>=T*nnz(interceptionInd) && flagMS==1 && flagM==0 ) 
            
            
            OS=OS+1;
            StatesM(2,i)=1;
            flagM=1;
         
        end         
         
          flagM=0;
          flagMS=0;
         
    end


    %% Under- Segmentation
    % Se considera subsegmentadas solo las regiones del MS
    
    
    for i=1:max(LabelsMS(:))%% Por cada mancha en la intercepcion entre GT y MS
    
        
        % primera condicion
        
        interceptionInd=(LabelsMS==i);
        
        intermedioGT=(LabelsGT).*(interceptionInd);  
                
        interGT=intermedioGT>0;
         
         inter2GT=intermedioGT(interGT);
         
         for j=1:max(LabelsGT(:))
             
             if(find(inter2GT==j))
                 
                 intermedioGTEval=intermedioGT(intermedioGT==j);
                 M = nnz(intermedioGTEval);%Count non-zero elements
                 j
                 M
                 T*nnz(GT(LabelsGT==j))
                 
                 if(M>=T*nnz(GT(LabelsGT==j)) && StatesM(1,i)~=1)%% Condicion sospechosa
                     
                     flagGT=1;
                     
                 
                 
                 end 
                 
             end    
             
             
         end
         
         % Segunda condicion
         
        M=nnz( intermedioGT);
        M
        if(M>=T*nnz(interceptionInd) && flagGT==1 && flagM==0) 
            
            
            US=US+1;
            StatesN(2,i)=1;
            flagM=1;
         
        end         
         
          flagM=0;
          flagGT=0;
         
    end

    %% Missed

    
      M=sum( not( sum(StatesN)));

    %% Noise
    
            
      N=sum( not(sum( StatesM)));


    
%end