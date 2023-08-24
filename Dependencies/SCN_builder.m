function [SCN,SCN_P,edgeNames]=SCN_builder(featureMatrix,nodenames,partials)
% INPUTS: 
% featuresMatrix is a matrix of data arranged with regions in rows and subjects in columns
% entries into "features matrix" represent ROI volumes, curvature,
% thickness, etc.
%nodenames
%partials are  optional, and should be a row for each partial and column for each subject

% OUTPUTS
% it will output and SCN matrix, a p-value matrix of the data and a matrix of all edge labels


%% dev note
%the position of the input argument is important! don't change
%unless you know what you are doing...

%% do work

    numFeats=size(featureMatrix,1); %the first dimension is rows
    SCN=zeros(numFeats); %preallocate
    SCN_P=zeros(numFeats); %preallocate
    %compute adjacency manually
    for i=1:numFeats
        %message=sprintf('calculating %s edges for node %d of %d total nodes',feature_of_interest,i, numFeats);
        %disp(message);
         for j=1:numFeats
             if(nargin<3) %if there are fewer than 3 arguements (if partials are not specified)
                [R,p]=corrcoef(featureMatrix(i,:)',featureMatrix(j,:)');
                R=R(1,2);
                p=p(1,2);
             else
                [R,p]=partialcorr(featureMatrix(i,:)',featureMatrix(j,:)',partials); %i think the partials need to be transposed, might want to consider features matrix transpose..... eek
             end
         SCN(i,j)=R;
         SCN_P(i,j)=p;
         end
         if i==j
            SCN(i,j)=0; %"disconnect" self-connections
         end
    end

    %name all the edges as "ROI_i-ROI_j"
    N=numFeats;
    edgeNames=cell(N);
    for j=1:N
        for i=1:N      
            edgeNames(i,j)={sprintf('%s + %s', nodenames{i}, nodenames{j})};
        end
    end

end