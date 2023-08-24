function [FeatureMatrix_1,FeatureMatrix_2]=SCN_featureMatrix_maker(list_1,list_2,datatype,data_dir)
% "datatype" is the morphometric feature and the corresponding column in the
% data file. "data_dir" is the directory to the parcellation data

%Set directory to cycle through all files
root=[pwd filesep];
S=dir(fullfile(data_dir,'*'));
N = setdiff({S([S.isdir]).name},{'.','..'});

for h=1:size(datatype,2)
    FeatureMatrix_1.(datatype{1,h})=zeros(358,numel(list_1));
    FeatureMatrix_2.(datatype{1,h})=zeros(358,numel(list_2));
    disp (datatype{1,h})
    % Build Feature Matrix
    for i=1:numel(N)
        subjectID=str2double(N{i});
        for j=1:numel(list_1)
            if subjectID==list_1(j,1) 
                subjectdir=[data_dir, filesep , N{i}];
                cd(subjectdir)
                lh=readmatrix(['.' filesep 'tables' filesep 'table_lh_values']);
                subjectdatafmlh=lh(:,datatype{2,h}); %build matrix from loaded parcelation table. (vol, curvature, thickness)
                rh=readmatrix(['.' filesep 'tables' filesep 'table_rh_values']);
                subjectdatafmrh=rh(:,datatype{2,h}); %build matrix from loaded parcelation table. (vol, curvature, thickness)
                cd(root)
                FeatureMatrix_1.(datatype{1,h})(:,(j))=[subjectdatafmlh; subjectdatafmrh];
            else
                continue
            end
        end
        for k=1:numel(list_2)
            if subjectID==list_2(k,1)  
                subjectdir=[data_dir, filesep, N{i}];
                cd(subjectdir)
                lh=readmatrix(['.' filesep 'tables' filesep 'table_lh_values']);
                subjectdatafmlh=lh(:,datatype{2,h}); %build feature matrix from loaded parcellation table. (vol, curvature, thickness)
                rh=readmatrix(['.' filesep 'tables' filesep 'table_rh_values']);
                subjectdatafmrh=rh(:,datatype{2,h}); %build matrix from loaded parcelation table. (vol, curvature, thickness)
                cd(root)
                FeatureMatrix_2.(datatype{1,h})(:,(k))=[subjectdatafmlh; subjectdatafmrh];
            else
                continue
            end
        end
    end
end
