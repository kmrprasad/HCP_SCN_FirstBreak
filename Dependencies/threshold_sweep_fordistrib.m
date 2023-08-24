function [ThreshNet_1, ThreshNet_2, ecc_1, meanecc_1, stdecc_1, ecc_2, meanecc_2, stdecc_2, lambda_1, lambda_2, BC_1, stdBC_1, BC_one, BC_2, stdBC_2, BC_two, C_1, stdC_1, CC_1, C_2, stdC_2, CC_2, deg_1, stddeg_1, deg_one, deg_2, stddeg_2, deg_two,EC_one, EC_1, stdEC_1, EC_two, EC_2, stdEC_2, Ci_1, Ci_2, mod_1, mod_2, r_1, r_2]=threshold_sweep_fordistrib(SCN_1,SCN_2,threshvals)
    for t=1:size(threshvals,2)
        threshold=threshvals(1,t);
        [binaryNetwork_1] = threshold_intensity(SCN_1,threshold);
        [binaryNetwork_2] = threshold_intensity(SCN_2,threshold);
        
        %Save Networks
        ThreshNet_1(:,:,t)=binaryNetwork_1;
        ThreshNet_2(:,:,t)=binaryNetwork_2;
    
        %Calulate Characteristic Path Length
        %SCN_1
        [~,Dist]=reachdist(binaryNetwork_1);
        [lambda_1(t), ~, ecc_1(:,t), ~, ~] = charpath(Dist,0,0); 
        meanecc_1(t)=mean(ecc_1(:,t));
        stdecc_1(t)=std(ecc_1(:,t));
        %SCN_2
        [~,Dist]=reachdist(binaryNetwork_2);
        [lambda_2(t), ~, ecc_2(:,t), ~, ~] = charpath(Dist,0,0);
        meanecc_2(t)=mean(ecc_2(:,t));
        stdecc_2(t)=std(ecc_2(:,t));
        
        %Calculate clustering coefficient
        %SCN_1
        CC_1(:,t)=clustering_coef_bu(binaryNetwork_1);
        C_1(t)=mean(CC_1(:,t));
        stdC_1(t)=std(CC_1(:,t));
        %SCN_2
        CC_2(:,t)=clustering_coef_bu(binaryNetwork_2);
        C_2(t)=mean(CC_2(:,t));
        stdC_2(t)=std(CC_2(:,t));
        
        %Calculate Betweenness Centrality
        BC_one(:,t)=betweenness_bin(binaryNetwork_1);
        BC_1(t)=mean(BC_one(:,t));
        stdBC_1(t)=std(BC_one(:,t));
        %SCN_2
        BC_two(:,t)=betweenness_bin(binaryNetwork_2);
        BC_2(t)=mean(BC_two(:,t));
        stdBC_2(t)=std(BC_two(:,t));
        
        %Calculate degree
        [deg_one(:,t)]=degrees_und(binaryNetwork_1);
        deg_1(t)=mean(deg_one(:,t));
        stddeg_1(t)=std(deg_one(:,t));
        %SCN_2
        [deg_two(:,t)]=degrees_und(binaryNetwork_2);
        deg_2(t)=mean(deg_two(:,t));
        stddeg_2(t)=std(deg_two(:,t));
        
        %Eigenvector centrality
        EC_one(:,t)=eigenvector_centrality_und(binaryNetwork_1);
        EC_1(t)=mean(EC_one(:,t));
        stdEC_1(t)=std(EC_one(:,t));
        %SCN_2
        EC_two(:,t)=eigenvector_centrality_und(binaryNetwork_2);
        EC_2(t)=mean(EC_two(:,t));
        stdEC_2(t)=std(EC_two(:,t));
        
        %Calculate Modularity
        [Ci_1(:,t),mod_1(1,t)]=modularity_und(binaryNetwork_1,1);
        %SCN_2
        [Ci_2(:,t),mod_2(1,t)]=modularity_und(binaryNetwork_2,1);
        
        %Calculate Assortativity
        r_1(t) = assortativity_bin(binaryNetwork_1,0);
        r_2(t) = assortativity_bin(binaryNetwork_2,0);
        
    end
end