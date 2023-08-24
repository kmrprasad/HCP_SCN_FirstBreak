function [Hublist_EC, Hublist_BC, Hublist_deg]=hubs_find(SCN, smwrld_range)
% Inputs: 
%SCN= Structural Covariance Network, smwrld_range= vector with range of threshold values to be analyzed
%threshname= cell array same size as smwrld_range (required for naming purposes)
% Outputs:
%list of hubs for each threshold value for each measure (BC, EC, degree)

for i=1:size(smwrld_range,2)
    %Threshold Network
    P=smwrld_range(i);
    [t_network]=threshold_intensity(SCN,P);
    
    % Betweenness Centrality
    BC(:,i)=betweenness_bin(t_network);
    mean_BC(:,i)=mean(BC(:,i));
    std_BC(:,i)=std(abs(BC(:,i)));      
    
    % Degree
    [deg(:,i)] = degrees_und(t_network);
    mean_deg(:,i)=mean(deg(:,i));
    std_deg(:,i)=std(deg(:,i));
     
     % Eigenvector Centrality
     EC(:,i)= eigenvector_centrality_und(t_network);
     mean_EC(:,i)=mean(EC(:,i));
     std_EC(:,i)=std(EC(:,i));
     
     Hublist_EC(:,i)=zeros(358,1);
     Hublist_BC(:,i)=zeros(358,1);
     Hublist_deg(:,i)=zeros(358,1);
     for n=1:size(SCN,1)
        if EC(n,i) > mean_EC(:,i) + (2*std_EC(:,i))
            Hublist_EC(n,i)=n;
        end
        if BC(n,i) > mean_BC(:,i) + (2*std_BC(:,i))
            Hublist_BC(n,i)=n;
        end
        if deg(n,i) > mean_deg(:,i) + (2*std_deg(:,i))
            Hublist_deg(n,i)=n;
        end
    end
    Hublist_EC(:,i)=sort(Hublist_EC(:,i),'descend');
    Hublist_BC(:,i)=sort(Hublist_BC(:,i),'descend');
    Hublist_deg(:,i)=sort(Hublist_deg(:,i),'descend');
end
