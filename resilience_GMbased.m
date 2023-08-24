%% Resilience Test Simulations
%Create list of nodes and their number
list=(1:358)';
load('HCP_atlasnames.mat');
nodenames=roinames;

%% Targeted Attack based on Betweenness Centrality HC
for h=1:size(HCPdata,2)
    for i=1:size(smwrld_range,2)
        SCN1_tb=ThreshNet_1(:,:,i,h);
        BC1=[list, BC_one(:,i,h)];
        BC1=sortrows(BC1, 2, 'descend');
        for x=1:358
            %set all rows and columns belonging to the node in xth position to zero
            SCN1_tb(:,BC1(x,1))=0;
            SCN1_tb(BC1(x,1),:)=0;

            %Efficiency
            Eglob1_BC(x,i,h) = efficiency_bin(SCN1_tb);

            % find size of largest collection of nodes.
            a = get_components(SCN1_tb); %get_components is a ECT function
            c = arrayfun(@(x)length(find(a == x)), unique(a), 'Uniform', false); %gets the number of instances of each unique entry
            cc = cell2mat(c); %have to convert to matrix
            size_GCC1_BC(x,i,h) = max(cc); %max(cc) will be the number of nodes in largest component.
            clear a c cc
        end
        clear BC1 SCN1_tb
    end
end
%% Targeted Attack based on Betweenness Centrality FEAP
for h=1:size(HCPdata,2)
    for i=1:size(smwrld_range,2)
        SCN2_tb=ThreshNet_2(:,:,i,h);
        BC2=[list, BC_two(:,i,h)];
        BC2=sortrows(BC2, 2, 'descend');
        for x=1:358
            %set all rows and columns belonging to the node in xth position to zero
            SCN2_tb(:,BC2(x,1))=0;
            SCN2_tb(BC2(x,1),:)=0;

            %Efficiency
            Eglob2_BC(x,i,h) = efficiency_bin(SCN2_tb);

            % find size of largest collection of nodes.
            a = get_components(SCN2_tb); %get_components is a BCT function
            c = arrayfun(@(x)length(find(a == x)), unique(a), 'Uniform', false); %gets the number of instances of each unique entry
            cc = cell2mat(c); %have to convert to matrix
            size_GCC2_BC(x,i,h) = max(cc); %max(cc) will be the number of nodes in largest component.
            clear a c cc
        end
        clear BC2 SCN2_tb
    end
end
%% Plot GCC and Eff -Surface Area
% Figure 5 in manuscript
percent=list/358;
percent=percent*100;

figure(1)
subplot(2,2,1)
scatter(percent, size_GCC1_BC(:,1,h), 'r')
hold on
scatter(percent, size_GCC1_BC(:,2,h), 'b')
hold on
scatter(percent, size_GCC1_BC(:,3,h), 'g')
hold on
scatter(percent, size_GCC1_BC(:,4,h), 'k')
hold on
scatter(percent, size_GCC1_BC(:,5,h), 'c')
hold on
scatter(percent, size_GCC1_BC(:,6,h), 'r')
hold on
scatter(percent, size_GCC1_BC(:,7,h), 'b')
hold on
scatter(percent, size_GCC1_BC(:,8,h), 'g')
hold on
scatter(percent, size_GCC1_BC(:,9,h), 'k')
hold on
title('HC Attack Based on BC- Cortical Thickness', 'FontSize', 18)
ylabel('Giant Connected Component', 'FontSize', 12)
xlabel('Percentage of Nodes Removed', 'FontSize', 14)
legend('0.075','0.1','0.125','0.15','0.175','0.2', '0.225', '0.25', '0.275', 'Location', 'northeast', 'FontSize', 12)

subplot(2,2,2)
scatter(percent, Eglob1_BC(:,1,h), 'r')
hold on
scatter(percent, Eglob1_BC(:,2,h), 'b')
hold on
scatter(percent, Eglob1_BC(:,3,h), 'g')
hold on
scatter(percent, Eglob1_BC(:,4,h), 'k')
hold on
scatter(percent, Eglob1_BC(:,5,h), 'c')
hold on
scatter(percent, Eglob1_BC(:,6,h), 'r')
hold on
scatter(percent, Eglob1_BC(:,7,h), 'b')
hold on
scatter(percent, Eglob1_BC(:,8,h), 'g')
hold on
scatter(percent, Eglob1_BC(:,9,h), 'k')
hold on
title('HC Attack Based on BC- Cortical Thickness', 'FontSize', 18)
ylabel('Global Efficiency', 'FontSize', 12)
xlabel('Percentage of Nodes Removed', 'FontSize', 14)
legend('0.075','0.1','0.125','0.15','0.175','0.2', '0.225', '0.25', '0.275', 'Location', 'northeast', 'FontSize', 12)

subplot(2,2,3)
scatter(percent, size_GCC2_BC(:,1,h), 'r')
hold on
scatter(percent, size_GCC2_BC(:,2,h), 'b')
hold on
scatter(percent, size_GCC2_BC(:,3,h), 'g')
hold on
scatter(percent, size_GCC2_BC(:,4,h), 'k')
hold on
scatter(percent, size_GCC2_BC(:,5,h), 'c')
hold on
scatter(percent, size_GCC2_BC(:,6,h), 'r')
hold on
scatter(percent, size_GCC2_BC(:,7,h), 'b')
hold on
scatter(percent, size_GCC2_BC(:,8,h), 'g')
hold on
scatter(percent, size_GCC2_BC(:,9,h), 'k')
hold on
title('FEAP Attack Based on BC- Cortical Thickness', 'FontSize', 18)
ylabel('Giant Connected Component', 'FontSize', 12)
xlabel('Percentage of Nodes Removed', 'FontSize', 14)
legend('0.075','0.1','0.125','0.15','0.175','0.2', '0.225', '0.25', '0.275', 'Location', 'northeast', 'FontSize', 12)

subplot(2,2,4)
scatter(percent, Eglob2_BC(:,1,h), 'r')
hold on
scatter(percent, Eglob2_BC(:,2,h), 'b')
hold on
scatter(percent, Eglob2_BC(:,3,h), 'g')
hold on
scatter(percent, Eglob2_BC(:,4,h), 'k')
hold on
scatter(percent, Eglob2_BC(:,5,h), 'c')
hold on
scatter(percent, Eglob2_BC(:,6,h), 'r')
hold on
scatter(percent, Eglob2_BC(:,7,h), 'b')
hold on
scatter(percent, Eglob2_BC(:,8,h), 'g')
hold on
scatter(percent, Eglob2_BC(:,9,h), 'k')
hold on
title('FEAP Attack Based on BC- Cortical Thickness', 'FontSize', 18)
ylabel('Global Efficiency', 'FontSize', 12)
xlabel('Percentage of Nodes Removed', 'FontSize', 14)
legend('0.075','0.1','0.125','0.15','0.175','0.2', '0.225', '0.25', '0.275', 'Location', 'northeast', 'FontSize', 12)

%% Targeted Attack based on Eigenvector Centrality HC
for h=1:size(HCPdata,2)
    for i=1:size(smwrld_range,2)
        SCN1_te=ThreshNet_1(:,:,i,h);
        EC1=[list, EC_one(:,i,h)];
        EC1=sortrows(EC1, 2, 'descend');
        for x=1:358
            %set all rows and columns belonging to the node in xth position to zero
            SCN1_te(:,EC1(x,1))=0;
            SCN1_te(EC1(x,1),:)=0;

            %Efficiency
            Eglob1_EC(x,i,h) = efficiency_bin(SCN1_te);

            % find size of largest collection of nodes.
            a = get_components(SCN1_te); %get_components is a ECT function
            c = arrayfun(@(x)length(find(a == x)), unique(a), 'Uniform', false); %gets the number of instances of each unique entry
            cc = cell2mat(c); %have to convert to matrix
            size_GCC1_EC(x,i,h) = max(cc); %max(cc) will be the number of nodes in largest component.
            clear a c cc
        end
        clear EC1 SCN1_te
    end
end
%% Targeted Attack based on Eigenvector Centrality FEAP
for h=1:size(HCPdata,2)
    for i=1:size(smwrld_range,2)
        SCN2_te=ThreshNet_2(:,:,i,h);
        EC2=[list, EC_two(:,i,h)];
        EC2=sortrows(EC2, 2, 'descend');
        for x=1:358
            %set all rows and columns belonging to the node in xth position to zero
            SCN2_te(:,EC2(x,1))=0;
            SCN2_te(EC2(x,1),:)=0;

            %Efficiency
            Eglob2_EC(x,i,h) = efficiency_bin(SCN2_te);

            % find size of largest collection of nodes.
            a = get_components(SCN2_te); %get_components is a ECT function
            c = arrayfun(@(x)length(find(a == x)), unique(a), 'Uniform', false); %gets the number of instances of each unique entry
            cc = cell2mat(c); %have to convert to matrix
            size_GCC2_EC(x,i,h) = max(cc); %max(cc) will be the number of nodes in largest component.
            clear a c cc
        end
        clear EC2 SCN2_te
    end
end

%% Plot GCC and Eff 
% Supplemental Figures
percent=list/358;
percent=percent*100;

figure(1)
subplot(2,2,1)
scatter(percent, size_GCC1_EC(:,1,h), 'r')
hold on
scatter(percent, size_GCC1_EC(:,2,h), 'b')
hold on
scatter(percent, size_GCC1_EC(:,3,h), 'g')
hold on
scatter(percent, size_GCC1_EC(:,4,h), 'k')
hold on
scatter(percent, size_GCC1_EC(:,5,h), 'c')
hold on
scatter(percent, size_GCC1_EC(:,6,h), 'r')
hold on
scatter(percent, size_GCC1_EC(:,7,h), 'b')
hold on
scatter(percent, size_GCC1_EC(:,8,h), 'g')
hold on
scatter(percent, size_GCC1_EC(:,9,h), 'k')
hold on
title('HC Attack Based on EC- Cortical Thickness', 'FontSize', 18)
ylabel('Giant Connected Component', 'FontSize', 12)
xlabel('Percentage of Nodes Removed', 'FontSize', 14)
legend('0.075','0.1','0.125','0.15','0.175','0.2', '0.225', '0.25', '0.275', 'Location', 'northeast', 'FontSize', 12)

subplot(2,2,2)
scatter(percent, Eglob1_EC(:,1,h), 'r')
hold on
scatter(percent, Eglob1_EC(:,2,h), 'b')
hold on
scatter(percent, Eglob1_EC(:,3,h), 'g')
hold on
scatter(percent, Eglob1_EC(:,4,h), 'k')
hold on
scatter(percent, Eglob1_EC(:,5,h), 'c')
hold on
scatter(percent, Eglob1_EC(:,6,h), 'r')
hold on
scatter(percent, Eglob1_EC(:,7,h), 'b')
hold on
scatter(percent, Eglob1_EC(:,8,h), 'g')
hold on
scatter(percent, Eglob1_EC(:,9,h), 'k')
hold on
title('HC Attack Based on EC- Cortical Thickness', 'FontSize', 18)
ylabel('Global Efficiency', 'FontSize', 12)
xlabel('Percentage of Nodes Removed', 'FontSize', 14)
legend('0.075','0.1','0.125','0.15','0.175','0.2', '0.225', '0.25', '0.275', 'Location', 'northeast', 'FontSize', 12)

subplot(2,2,3)
scatter(percent, size_GCC2_EC(:,1,h), 'r')
hold on
scatter(percent, size_GCC2_EC(:,2,h), 'b')
hold on
scatter(percent, size_GCC2_EC(:,3,h), 'g')
hold on
scatter(percent, size_GCC2_EC(:,4,h), 'k')
hold on
scatter(percent, size_GCC2_EC(:,5,h), 'c')
hold on
scatter(percent, size_GCC2_EC(:,6,h), 'r')
hold on
scatter(percent, size_GCC2_EC(:,7,h), 'b')
hold on
scatter(percent, size_GCC2_EC(:,8,h), 'g')
hold on
scatter(percent, size_GCC2_EC(:,9,h), 'k')
hold on
title('FEAP Attack Based on EC- Cortical Thickness', 'FontSize', 18)
ylabel('Giant Connected Component', 'FontSize', 12)
xlabel('Percentage of Nodes Removed', 'FontSize', 14)
legend('0.075','0.1','0.125','0.15','0.175','0.2', '0.225', '0.25', '0.275', 'Location', 'northeast', 'FontSize', 12)

subplot(2,2,4)
scatter(percent, Eglob2_EC(:,1,h), 'r')
hold on
scatter(percent, Eglob2_EC(:,2,h), 'b')
hold on
scatter(percent, Eglob2_EC(:,3,h), 'g')
hold on
scatter(percent, Eglob2_EC(:,4,h), 'k')
hold on
scatter(percent, Eglob2_EC(:,5,h), 'c')
hold on
scatter(percent, Eglob2_EC(:,6,h), 'r')
hold on
scatter(percent, Eglob2_EC(:,7,h), 'b')
hold on
scatter(percent, Eglob2_EC(:,8,h), 'g')
hold on
scatter(percent, Eglob2_EC(:,9,h), 'k')
hold on
title('FEAP Attack Based on EC- Cortical Thickness', 'FontSize', 18)
ylabel('Global Efficiency', 'FontSize', 12)
xlabel('Percentage of Nodes Removed', 'FontSize', 14)
legend('0.075','0.1','0.125','0.15','0.175','0.2', '0.225', '0.25', '0.275', 'Location', 'northeast', 'FontSize', 12)
