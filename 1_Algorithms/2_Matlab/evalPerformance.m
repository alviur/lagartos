%================================
% 
%
%
%================================

%GT: Ground True
%MS: Machine Segmentation
%T: Tolerance
%CD: Correct Detection
%OS :Over-Segmentation
%US: Under-Segmentation
%M: Missed
%N: Noise


function [CD,US,OS,M,N]=evalPerformance(GT,MS,T)

% Inicialization
    OS=0;
    US=0;
    M=0;
    N=0;
    
    
    

%Label each image region
    LabelsGT = bwlabel(GT);
    LabelsMS = bwlabel(MS);
   %     RGB2 = label2rgb(LabelsMS);
    %imshow(RGB2)

    StatesM=zeros(3,max(LabelsMS(:)));
    StatesN=zeros(3,max(LabelsGT(:)));
    
    
   for i=1:max(LabelsGT(:))
 
       Pm(i) = nnz(LabelsGT(LabelsGT==i));%Count non-zero elements 
       
   end
   
  for i=1:max(LabelsMS(:))
       
       Pn(i) = nnz(LabelsMS(LabelsMS==i));%Count non-zero elements   
       
   end    
    
%% Correct Detection

   CD=0;

   interception=and(GT,MS);%interception
   LabelsInter = bwlabel(interception);


   InterceptionGT=(interception.*LabelsGT);%Label

   InterceptionMS=(interception.*LabelsMS);%Label
   
      

  
   
   for i=1:max(LabelsGT(:))

       manchaGTinterception=(InterceptionGT==i);
       n = nnz(manchaGTinterception);%Count non-zero elements
        

       if(n>=T*Pm(i) && n>=T*nnz(logical(manchaGTinterception).*logical(MS)))
           
           %CD=CD+1;
           StatesN(1,i)=n;
           
       else
           
       manchaGTinterception(manchaGTinterception==i)=0;
              
              
       end
       
   end
   
 
   
      for i=1:max(LabelsMS(:))

       manchaMSinterception=(InterceptionMS==i);
       n = nnz(manchaMSinterception);%Count non-zero elements
        

       if(n>=T*Pn(i) && n>=T*nnz(logical(manchaGTinterception).*logical(MS)))
           
           CD=CD+1;
           StatesM(1,i)=n;                 
              
       end
       
   end
   
 

%% Over- segmentation


      %imshow(logical(manchaGTinterception).*logical(MS))
        %waitforbuttonpress

 M_percent=zeros(max(InterceptionMS(:)),1);
 
 overInterceptionMS=InterceptionMS;
 
for i=1:max(LabelsMS(:))
    
   manchaMSinterception=(overInterceptionMS==i);
   
   
   M_percent(i)=nnz(manchaMSinterception);%Count non-zero elements
   if( M_percent(i)< T*Pm)
              
       overInterceptionMS(overInterceptionMS==i)=0;
       StatesM(1,i)=M_percent(i);
   
   end
    
end



  for i=1:max(LabelsGT(:))
       
       manchaGTinterception=(InterceptionGT==i);
       intermedio=overInterceptionMS.*manchaGTinterception;
       n = nnz(intermedio);%Count non-zero elements
       if( n>=T*nnz(MS) &&  n>StatesN(1,i) )
           StatesN(2,i)=1;
           OS=OS+1;
       
       
       end
       
   end
      


%% Under- Segmentation

 N_percent=zeros(max(InterceptionMS(:)),1);
for i=1:max(LabelsGT(:))
    
   N_percent(i)=nnz(manchaGTinterception);%Count non-zero elements
   if( N_percent(i)< T*Pn)       
       
       InterceptionGT(InterceptionGT==i)=0;
       
   else
       
   
   
   end
   
   
   

   
    
end


  for i=1:max(LabelsMS(:))
       
       manchaMSinterception=(InterceptionMS==i);
       intermedio=logical(GT).*logical(manchaMSinterception);
       
       imshow(intermedio)
       waitforbuttonpress
   
       M = nnz(intermedio);%Count non-zero elements
        M
        T*Pm(i)
        T*StatesM(1,1)
        
       if( M>=T*Pm(i) && M>StatesM(1,1))
          
           StatesM(3,i)=M;
           US=US+1;
       
       end
       
   end



%% Missed

M=0;
N=0;

for i=1:max(LabelsGT(:))

        if(StatesN(1,i)==0)M=M+1;end


end

%% Noise

for i=1:max(LabelsMS(:))

        if(StatesM(1,i)==0)N=N+1;end


end



end