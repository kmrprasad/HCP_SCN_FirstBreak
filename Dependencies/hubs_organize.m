%% Organize hubs
function [hubs_1, hubs_2] = hubs_organize(Hublist_BC_1, Hublist_BC_2, Hublist_EC_1, Hublist_EC_2, ... 
    Hublist_deg_1, Hublist_deg_2)
%Function to organize hubs over a threshold range or over a number of
%subjects

n=1:length(Hublist_BC_1);
t=zeros(length(Hublist_BC_1),1);

hubs_1=[n',t];
hubs_2=[n',t];
    
% First Group    
for k=1:size(Hublist_BC_1,2)
    hublist_1=[Hublist_BC_1(:,k); Hublist_EC_1(:,k); Hublist_deg_1(:,k)];
    %sort so hubs are at top
    hublist_1=unique(hublist_1);
    Hublist_1(:,k)=[hublist_1; zeros(length(n)-length(hublist_1),1)];
    clear hublist_1
end
for k=1:size(Hublist_BC_1,2)
    for x=1:length(Hublist_BC_1)
        for y=1:length(Hublist_BC_1)
            if x==Hublist_1(y,k)
                hubs_1(x,2)=hubs_1(x,2)+1;
            end
        end
    end
end

% Second Group
for k=1:size(Hublist_BC_2,2)
    hublist_2=[Hublist_BC_2(:,k); Hublist_EC_2(:,k); Hublist_deg_2(:,k)];
    %sort so hubs are at top
    hublist_2=unique(hublist_2);
    Hublist_2(:,k)=[hublist_2; zeros(length(n)-length(hublist_2),1)];
    clear hublist_2
end
for k=1:size(Hublist_BC_2,2)
    for x=1:length(Hublist_BC_2)
        for y=1:length(Hublist_BC_2)
            if x==Hublist_2(y,k)
                hubs_2(x,2)=hubs_2(x,2)+1;
            end
        end
    end
end