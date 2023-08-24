function [S, R_connect]=threshold_smallworldness(SCN, intensity_vals)
% Inputs: 
%SCN= Structural Covariance Network, intensity_vals= vector with threshold values to be analyzed
%threshname= cell array same size as intensity_vals (required for naming
%purposes)
%Outputs:
%S=vector with values for sigma at each threshold R_connect=will give 1 when unconnected and 0 when connected
%when R_connect=1, prior threshold will be the upper limit, lower limit when sigma>1.2

for i=1:size(intensity_vals,2)
    clear newRandNet_1 path clust t_network R
    P=intensity_vals(i);
    [t_network]=threshold_intensity(SCN,P);
    [R,~] = reachdist(t_network);
    %Find when SCN is no longer fully connected 
    R_connect(1,i)= any(R == 0 , 'all');
    
    %Create random graph 200 times
    for j=1:200
        newRandNet= randomizer_bin_und(t_network,1);
        [~,rDist]=reachdist(newRandNet);
        [charpath_R1(j),~,~,~,~] = charpath(rDist);
        CC_R1=clustering_coef_bu(newRandNet);
        c_R1(j)=mean(CC_R1);
        clear CC_R1 newRandNet rDist
    end
    
    %Calculate Average pathlength
    [~,real_dist] = reachdist(t_network);
    [lambda_1,~,~,~,~] = charpath(real_dist);
    %SCN_R
    lambda_R1=mean(charpath_R1);    
    path=lambda_1/lambda_R1;

    %Calculate Clustering Coefficient
    %SCN_1
    CC_1=clustering_coef_bu(t_network);
    C_1=mean(CC_1);
    %SCN_R1
    C_R1=mean(c_R1);
    
    clust=C_1/C_R1;
    
    %Calculate sigma
    S(i)=clust/path;
end