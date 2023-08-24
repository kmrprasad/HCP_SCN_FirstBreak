%% Code for Analysis of Modules
load('HCPdata.mat')
HCPdata(:,4)=[];
smwrld_range=0.075:0.025:0.275;

% Number of Modules
for h=1:size(HCPdata,2)
    for t=1:length(smwrld_range)
        num_mods1(h,t)=max(Ci_1(:,t,h));
        num_mods2(h,t)=max(Ci_2(:,t,h));
    end
end

density_1=zeros(max(max(num_mods1)),length(smwrld_range),size(HCPdata,2));
avedeg_1=zeros(max(max(num_mods1)),length(smwrld_range),size(HCPdata,2));
density_2=zeros(max(max(num_mods1)),length(smwrld_range),size(HCPdata,2));
avedeg_2=zeros(max(max(num_mods1)),length(smwrld_range),size(HCPdata,2));

% Calculate density and average degree for all modules
for h=1:size(HCPdata,2)
    for t=1:length(smwrld_range)
        for j=1:num_mods1(h,t)
            SCN_mods=ThreshNet_1(:,:,t,h);
            ind=find(Ci_1(:,t,h) ~= j);
            SCN_mods(:,ind)=[];
            SCN_mods(ind,:)=[];
            [density_1(j,t,h),~,~]=density_und(SCN_mods);
            avedeg_1(j,t,h)=mean(degrees_und(SCN_mods),2);
            clear SCN_mods
        end

        for j=1:num_mods2(h,t)
            SCN_mods=ThreshNet_2(:,:,t,h);
            ind=find(Ci_2(:,t,h) ~= j);
            SCN_mods(:,ind)=[];
            SCN_mods(ind,:)=[];
            [density_2(j,t,h),~,~]=density_und(SCN_mods);
            avedeg_2(j,t,h)=mean(degrees_und(SCN_mods),2);
            clear SCN_mods
        end
    end
end