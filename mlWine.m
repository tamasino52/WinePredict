function quality = mlWine(trainXlsFileName, testXlsFileName)
%MLWINE Summary of this function goes here
%   Detailed explanation goes here

testData = readtable(testXlsFileName);
trainData = readtable(trainXlsFileName);

weight =  std(trainData{:,1:11}./3);

result = linspace(0,0,size(testData,1))';
for k=1: size(testData,1)
    idx = logical(linspace(1,1,size(trainData,1))');
    for j=1:size(trainData,1)
        for i=1:11
            if idx(j)==true && abs(trainData{j,i} - testData{k,i}) < weight(i)
                idx(j) = idx(j) & true;
            else
                idx(j) = idx(j) & false;
                break;
                
            end
        end
    end
    if sum(idx)~=0
        result(k,1) = mean(trainData.Quality(idx,:),1);
        %result(k,2) = median(trainData.Quality(idx,:),1);
        %result(k,3) = mode(trainData.Quality(idx,:),1);
        
    end
end




trainedModel = trainRegressionModel(trainData);

quality = trainedModel.predictFcn(testData(:,:));


quality(result(:,1)~=0,1) = result(result(:,1)~=0,1)

% totalS02의 이상치 처리
strangeIndex = testData.TotalS02 >350;
quality(strangeIndex) = 3;
% freeS02의 이상치 처리
strangeIndex = testData.FreeS02 >140;
quality(strangeIndex) = 3;

end

