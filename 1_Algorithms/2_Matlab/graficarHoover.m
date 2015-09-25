%==========================================================================
%
%
%
%==========================================================================


%function graficarHoover(CD,OS,US,M,N,regionesGT,regionesMS)

%load('original_belief1.mat')

CD=CD./regionesGT;
OS=OS./regionesGT;
US=US./regionesMS;
M=M./regionesGT;
na=N;
N=N./regionesMS;



N(isnan(N))=0;


    mCD=mean(CD);
    mOS=mean(OS);
    mUS=mean(US);
    mM=mean(M);
    mN=mean(N);
    mGT=mean(regionesGT);
    mMS=mean(regionesMS);
    
    mCD(isnan(mCD))=0;
    mUS(isnan(mUS))=0;
    mOS(isnan(mOS))=0;
    mM(isnan(mM))=0;
    mN(isnan(mN))=0;
% 
% 
%     %Over-segmentation
%     subplot(3,2,1)
%     plot([0.1:0.1:1],mOS)
%     axis([0.1 1 0 mGT(1)])
%     grid on
%     xlabel('Tolerance %') % x-axis label
%     ylabel('Average number of Over-segmented instances') % y-axis label
%     title('Over-Segmentation')
% 
%     %Under-segmentation
%     subplot(3,2,2)
%     plot([0.1:0.1:1],mUS)
%     axis([0.1 1 0 mMS(1)])
%     grid on
%     xlabel('Tolerance %') % x-axis label
%     ylabel('Average number of under-segmented instances') % y-axis label
%     title('Under-Segmentation')
% 
%     %Missed
%     subplot(3,2,3)
%     plot([0.1:0.1:1],mM)
%     axis([0.1 1 0 mGT(1)])
%     grid on
%     xlabel('Tolerance %') % x-axis label
%     ylabel('Average number of Missed instances') % y-axis label
%     title('Missed')
% 
%     %Noise
%     subplot(3,2,4)
%     plot([0.1:0.1:1],mN)
%     axis([0.1 1 0 mMS(1)])
%     grid on
%     xlabel('Tolerance %') % x-axis label
%     ylabel('Average number of Noise instances') % y-axis label
%     title('Noise')
% 
%     %Correct Detection
%     subplot(3,2,5)



    hold on
    plot([0.1:0.1:1],mM,'b--o','Color',[0,0,0])
    axis([0.1 1 0 1])
    grid on
    xlabel('Tolerance %') % x-axis label
    ylabel('Average number of Missed instances') % y-axis label
    title('Missed instances')
    legend('w=3','w=6','w=9','w=12','w=15','w=18','w=21','w=24','w=27','w=30','w=33','w=36','w=39','w=42','w=45','w=48')
    %set(gca, 'XTickLabel',str, 'XTick',1:numel(str))
    set(findall(gca, 'Type', 'Line'),'LineWidth',2);
    
    
%end
