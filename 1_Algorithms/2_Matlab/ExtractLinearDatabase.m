
numeroImagenes=20;
path='/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/true/';
pathGround='/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/Ground/';



intensidad=cell(1,numeroImagenes);

rgb=cell(1,numeroImagenes);


for(i=20 :numeroImagenes)
    i
    numeroToString = int2str(i);
    fileName = strcat(path,numeroToString);
    fileNameGround = strcat(pathGround,numeroToString);
    fileName = strcat(fileName,'.jpg');
   
    I1 = imread(fileName);
    IGround = imread(fileNameGround);
    I1=imresize(I1, [100 100]);
    IGround=imresize(IGround, [100 100]);
    
    
    
    I1=I1(:,:,1);
   
    I1(I1<250)=0;
        imshow(I1)
    waitfoebuttonpress
    
    %I1=logical(I1);
    I1(I1>0)=1;
   % imshow(I1)
 
    intensidad{1,i}=extractLinearIntensities(I1); 
    rgb{1,i}=extractLinearRGBIntensities(IGround);


end


% resultado100test=cell(1,6);
% 
% for i=1:6
%     
%    resultado100test{i}=vec2mat(R{1}.labels{1,i},100);
%    
%     resultado100test{i}(resultado100test{i}>0)=255;
%     
%     
% end
% 
% testSeqs=cell(1,6);
% testLabels=cell(1,6);
% 
% for i=1:6
%     
% testSeqs{1,i}=rgb{1,i+14};
% testLabels{1,i}=intensidad{1,i+14};
% 
% end
% 
% 
% newLabel=cell(1,6);
% 
% for i=1:6
%     
%     [valor,class]=max(R{1}.ll{i}(:,:));
%     b=class;
% 
%     for j=1:size(b,2)
%          if (b(j)==2) 
%              
%              b(j)=255;
%          else
%              b(j)=0;
%          
%          end
%         
%      end
%     
%         a=vec2mat(b,100);
%     
% 
%     newLabel{1,i}=a;
%     
% 
% end
