% Code for resilience simulations 
% Based on Betweenness Centrality (BC) and Eigenvector Centrality (EC) for
% removals 
%% Load data, calculate graph measures, and sort 
load('HCPdata.mat');
HCPdata(:,4)=[];

SCN_1=load('SCNpar_3_thick.csv'); %HC
SCN_2=load('SCNpar_4_thick.csv'); %FEAP

SCN_1=abs(SCN_1);
SCN_2=abs(SCN_2);


SCN_1t=threshold_intensity(SCN_1,0.275);
SCN_2t=threshold_intensity(SCN_2,0.275);

BC_1=betweenness_bin(SCN_1t);
BC_2=betweenness_bin(SCN_2t);

list=(1:358)';

BC1=[list, BC_1'];
BC1=sortrows(BC1,2, 'descend');

BC2=[list, BC_2'];
BC2=sortrows(BC2,2, 'descend');

its_threshold=0.275;
filename1='HC_intensThresh.txt';
filename2='FEAP_intensThresh.txt';

intensityThreshold(filename1,SCN_1,its_threshold); %threshold again
intensityThreshold(filename2,SCN_2,its_threshold); %threshold again

 [it_replace_before1,~,~,~] = DeltaCon('edge', 'naive', filename1, filename2, 0.1); %FEAP v HC
%% Targeted Attack based on Betweenness Centrality at known disintegration 
%FEAP v HC
SCN1_tb=SCN_1;
SCN2_tb=SCN_2;
for x=1:202 %Point of FEAP disintegraation
        %set all rows and columns belonging to the node in xth position to zero
        SCN2_tb(:,BC2(x,1))=0;
        SCN2_tb(BC2(x,1),:)=0;

         intensityThreshold(filename2,SCN2_tb,its_threshold); %threshold again

         %set all rows and columns belonging to the node in xth position to zero
        SCN1_tb(:,BC1(x,1))=0;
        SCN1_tb(BC1(x,1),:)=0;
         
         intensityThreshold(filename1,SCN1_tb,its_threshold); %threshold again
                 
        [it_replace1(x),~,~,~] = DeltaCon('edge', 'naive', filename1, filename2, 0.1);
end

% for x=202:358 %Point of FEAP disintegraation
%         %set all rows and columns belonging to the node in xth position to zero
%         SCN3_tb(:,BC3(x,1))=0;
%         SCN3_tb(BC3(x,1),:)=0;
% 
%          intensityThreshold(filename2,SCN3_tb,its_threshold); %threshold again
% 
%          %set all rows and columns belonging to the node in xth position to zero
%         SCN4_tb(:,BC4(x,1))=0;
%         SCN4_tb(BC4(x,1),:)=0;
%          
%          intensityThreshold(filename1,SCN4_tb,its_threshold); %threshold again
%                  
%         [it_replace_a1(x-201),~,~,~] = DeltaCon('edge', 'naive', filename1, filename2, 0.1);
% end
%% Figure 6 in manuscript
nodesrem1=0:202;
total_simscore1=[it_replace_before1 it_replace1];

figure(1)
scatter(nodesrem1, total_simscore1)
xlabel('Number of Nodes Removed in the Descending Order of BC', 'FontSize', 14)
ylabel('DeltaCon Similarity Score', 'FontSize', 14)
title('Similarity Score of FEAP and HC Networks during BC-based Targeted Cumulative Attack Before FEAP SCN Disintegration', 'FontSize', 14)
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 24;
ax.FontWeight = 'bold';
