% Sample code for analysis in "Modular Architecture and resilience of
% structural covariance networks in first-episode antipsychotic naive
% psychoses"
% Sample code includes two groups 1=control and 2=FEAP. Other groups were
% also analyzed but not included in this code for simplicity

%% Automatically Add Directories To Path
%Add Path of Dependencies
UtilityFolder='./Dependencies/';
addpath(genpath(UtilityFolder)); %genpath() adds subfolders also

%Add Path of Brain Connectivity Toolbox
BCTFolder='/Users/user/Documents/Pitt/Concept_Lab/HCP_SCN_mlewis/BCT/2019_03_03/BCT/';
addpath(genpath(BCTFolder));
%% Create Feature Matrices for HCP Atlas
%Create a excel sheet for each group with column 1= subject ID and column 2,3,...
%equal to data needed for partial correlation (age,sex, etc)
list_1=readmatrix('HCB.xlsx'); %Healthy Control
list_2=readmatrix('FBB.xlsx'); %First Break

%Load the data type (column) and location in data table
load([ UtilityFolder 'sampledata/HCPdata.mat']);
HCPdata(:,4)=[];
datatype=HCPdata;
%Directory to HCP atlas parcelations and morphpmetric data tables
data_dir=([UtilityFolder '/sampledata/HCP_parcelation/']);

[FeatureMatrix_1,FeatureMatrix_2]=SCN_featureMatrix_maker(list_1(:,1),list_2(:,1),datatype,data_dir); %Controls and First-break groups

%% Create partials matrix
%sum volume
for s=1:size(FeatureMatrix_1.vol,2)
    cortvol_1(s,1)=sum(FeatureMatrix_1.vol(:,s));
    surfarea_1(s,1)=sum(FeatureMatrix_1.SA(:,s));
    cortthick_1(s,1)=sum(FeatureMatrix_1.thick(:,s));
end
for s=1:size(FeatureMatrix_2.vol,2)
    cortvol_2(s,1)=sum(FeatureMatrix_2.vol(:,s));
    surfarea_2(s,1)=sum(FeatureMatrix_2.SA(:,s));
    cortthick_2(s,1)=sum(FeatureMatrix_2.thick(:,s));
end

partials_1.vol=[list_1(:,2),list_1(:,3),cortvol_1];
partials_2.vol=[list_2(:,2),list_2(:,3),cortvol_2];

partials_1.SA=[list_1(:,2),list_1(:,3),surfarea_1];
partials_2.SA=[list_2(:,2),list_2(:,3),surfarea_2];

partials_1.thick=[list_1(:,2),list_1(:,3),cortthick_1./(size(FeatureMatrix_1.thick,1))];
partials_2.thick=[list_2(:,2),list_2(:,3),cortthick_2./(size(FeatureMatrix_2.thick,1))];

%save('partialdata.mat', 'partials_1', 'partials_2', 'partials_3', 'partials_4')
%% Node names
load('HCP_atlasnames.mat');
nodenames=roinames;

%% SCN Builder
% two or more SCNs must be made
% ideally, each of these sections consists of 1 line, or a single function
% in a loop perhaps
% use "utility/SCN_builder.m" to make the SCN from the features matrix
% needs to be flexible, need to make a "partial correlation" vers

for h=1:size(HCPdata,2)
    [SCN_1(:,:,h),SCN_P_1(:,:,h),~]=SCN_builder(FeatureMatrix_1.(HCPdata{1,h}),nodenames,partials_1.(HCPdata{1,h}));
    [SCN_2(:,:,h),SCN_P_2(:,:,h),~]=SCN_builder(FeatureMatrix_2.(HCPdata{1,h}),nodenames,partials_2.(HCPdata{1,h}));

    SCN_1(:,:,h)=abs(SCN_1(:,:,h));
    SCN_2(:,:,h)=abs(SCN_2(:,:,h));
end

%% Calculate Sigma (Intensity) For finding threshold (small worldness) range
intensity_vals=0:.025:1;
for h=1:size(HCPdata,2)
   [Si_1(:,:,h), R_connect_1(:,:,h)]=threshold_smallworldness(SCN_1(:,:,h), intensity_vals);
   [Si_2(:,:,h), R_connect_2(:,:,h)]=threshold_smallworldness(SCN_2(:,:,h), intensity_vals);
end
%% Finding Network Distrib/ Graph measures across small worldness range
% Set threshold range after comparing smallworldness range for all groups
smwrld_range=0.075:0.025:0.275;
for h=1:size(HCPdata,2)
    [ThreshNet_1(:,:,:,h), ThreshNet_2(:,:,:,h), ecc_1(:,:,h), meanecc_1(:,:,h), stdecc_1(:,:,h), ecc_2(:,:,h), meanecc_2(:,:,h), stdecc_2(:,:,h), lambda_1(:,:,h), lambda_2(:,:,h), BC_1(:,:,h), stdBC_1(:,:,h), BC_one(:,:,h), BC_2(:,:,h), stdBC_2(:,:,h), BC_two(:,:,h), C_1(:,:,h), stdC_1(:,:,h), CC_1(:,:,h), C_2(:,:,h), stdC_2(:,:,h), CC_2(:,:,h), deg_1(:,:,h), stddeg_1(:,:,h), deg_one(:,:,h), deg_2(:,:,h), stddeg_2(:,:,h), deg_two(:,:,h), EC_one(:,:,h), EC_1(:,:,h), stdEC_1(:,:,h), EC_two(:,:,h), EC_2(:,:,h), stdEC_2(:,:,h), Ci_1(:,:,h), Ci_2(:,:,h), mod_1(:,:,h), mod_2(:,:,h), r_1(:,:,h), r_2(:,:,h)]=threshold_sweep_fordistrib(SCN_1(:,:,h),SCN_2(:,:,h),smwrld_range);
end
%% Find Hubs using Intensity
smwrld_range=0.075:0.025:0.275;
for h=1:size(HCPdata,2)
    [Hublist_EC_1(:,:,h), Hublist_BC_1(:,:,h), Hublist_deg_1(:,:,h)]=hubs_find(SCN_1(:,:,h), smwrld_range);
    [Hublist_EC_2(:,:,h), Hublist_BC_2(:,:,h), Hublist_deg_2(:,:,h)]=hubs_find(SCN_2(:,:,h), smwrld_range);
end
for h=1:size(HCPdata,2)
    [hubs_1(:,:,h), hubs_2(:,:,h)] = hubs_organize(Hublist_BC_1(:,:,h), Hublist_BC_2(:,:,h), Hublist_EC_1(:,:,h), Hublist_EC_2(:,:,h), Hublist_deg_1(:,:,h), Hublist_deg_2(:,:,h));
end
%% Find Modules
% Need to run Graph measures across small worlness range first 
% Other scripts written for module analysis. Please see ModuleAnalysis.m

%% Test resilience
% Need to run Graph measures across small worlness range first
% Other scripts written for types of removals. Please see
% reslience_GMbased.m to find disintegration point and then
% RemovalwDeltaCon to calculate similarity metric. 

%% Behavioral Analysis
High_neg=readmatrix('./HCP_paper/Behav_groups.xlsx', 'Sheet', 'Neg-High');
Low_neg=readmatrix('./HCP_paper/Behav_groups.xlsx', 'Sheet', 'Neg-Low');
High_pos=readmatrix('./HCP_paper/Behav_groups.xlsx', 'Sheet', 'Pos-High');
Low_pos=readmatrix('./HCP_paper/Behav_groups.xlsx', 'Sheet', 'Pos-Low');
load('HCPdata.mat');
HCPdata(:,4)=[];
datatype=HCPdata;
data_dir=(['.' filesep 'HCP_parcelation']);
[FeatureMatrix_High_neg,FeatureMatrix_Low_neg]=featurematrices_HCPcreate(High_neg(:,1),Low_neg(:,1),datatype,data_dir);
[FeatureMatrix_High_pos,FeatureMatrix_Low_pos]=featurematrices_HCPcreate(High_pos(:,1),Low_pos(:,1),datatype,data_dir);

load('HCP_atlasnames.mat');
nodenames=roinames;
for h=1:size(HCPdata,2)
    [SCN_High_neg.(HCPdata{1,h}),SCN_P_High_neg.(HCPdata{1,h}),~]=SCN_builder(FeatureMatrix_High_neg.(HCPdata{1,h}),nodenames);  
    [SCN_Low_neg.(HCPdata{1,h}),SCN_P_Low_neg.(HCPdata{1,h}),~]=SCN_builder(FeatureMatrix_Low_neg.(HCPdata{1,h}),nodenames);  
    [SCN_High_pos.(HCPdata{1,h}),SCN_P_High_pos.(HCPdata{1,h}),~]=SCN_builder(FeatureMatrix_High_pos.(HCPdata{1,h}),nodenames);  
    [SCN_Low_pos.(HCPdata{1,h}),SCN_P_Low_pos.(HCPdata{1,h}),edgeNames]=SCN_builder(FeatureMatrix_Low_pos.(HCPdata{1,h}),nodenames);  
end
threshvals=0.075:0.025:0.275;
[measures_1, measures_2, measures_3, measures_4, p_1_2, p_3_4, p_1_3, p_2_4]=behavorial_correlation(SCN_High_neg.vol,SCN_High_pos.vol,SCN_Low_neg.vol,SCN_Low_pos.vol,threshvals);

[~, High_char, ~, Hchar_stat]=ttest2(measures_1.lambda,measures_2.lambda);
[~, Low_char, ~, Lchar_stat]=ttest2(measures_3.lambda,measures_4.lambda);
[~, Pos_char, ~, Pchar_stat]=ttest2(mesaures_2.lambda,measures_3.lambda);
[~, Neg_char, ~, Nchar_stat]=ttest2(measures_1.lambda,measures_4.lambda);

[~, High_mod, ~, Hmod_stat]=ttest2(measures_3.mod(6,:),measures_3.mod(7,:));
[~, Low_mod, ~, Lmod_stat]=ttest2(measures_3.mod(8,:),measures_3.mod(9,:));
[~, Pos_mod, ~, Pmod_stat]=ttest2(measures_3.mod(7,:),measures_3.mod(8,:));
[~, Neg_mod, ~, Nmod_stat]=ttest2(measures_3.mod(6,:),measures_3.mod(9,:));

[~, High_assort, ~, Hassort_stat]=ttest2(measures_1.assort,measures_2.assort);
[~, Low_assort, ~, Lassort_stat]=ttest2(measures_3.assort,measures_3.assort);
[~, Pos_assort, ~, Passort_stat]=ttest2(measures_2.assort,measures_3.assort);
[~, Neg_assort, ~, Nassort_stat]=ttest2(measures_3.assort,measures_3.assort);

%Multiple test correction (7 measures total)
High_assort=High_assort*7;
Low_assort=Low_assort*7;
Pos_assort=Pos_assort*7;
Neg_assort=Neg_assort*7;

High_char=High_char*7;
Low_char=Low_char*7;
Pos_char=Pos_char*7;
Neg_char=Neg_char*7;

High_mod=High_mod*7;
Low_mod=Low_mod*7;
Pos_mod=Pos_mod*7;
Neg_mod=Neg_mod*7;

save('Ttest_GlobalBehavioralMeasures.mat')
