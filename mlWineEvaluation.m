function mse = mlWineEvaluation(trainXlsFileName, testXlsFileName, responseXlsFileName)
%MLWINEEVALUATION Summary of this function goes here
%   Detailed explanation goes here

quality = mlWine(trainXlsFileName, testXlsFileName);
trueQuality = readtable(responseXlsFileName);

mse = mean((quality - trueQuality.Quality).^2);

%end