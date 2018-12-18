function [trainedModel, validationRMSE] = trainRegressionModel(trainingData)
% [trainedModel, validationRMSE] = trainRegressionModel(trainingData)
% �Ʒõ� ȸ�� �𵨰� �� RMSE��(��) ��ȯ�մϴ�. �� �ڵ�� ȸ�� �н��� �ۿ��� �Ʒõ� ��
% �� �ٽ� ����ϴ�. ������ �ڵ带 ����Ͽ� ������ ���� �� �����ͷ� �Ʒý�Ű�� ���� �ڵ�
% ȭ�ϰų�, ���� ���α׷��� ������� �Ʒý�Ű�� ����� ���� �� �ֽ��ϴ�.
%
%  �Է°�:
%      trainingData: ������ ������ �Ͱ� ������ ���� ������ ���� ���� ���� �����ϴ� ��
%       �̺��Դϴ�.
%
%  ��°�:
%      trainedModel: �Ʒõ� ȸ�� ���� ���Ե� ����ü�Դϴ�. �� ����ü���� �Ʒõ� ��
%       ���� ���� ������ ���Ե� �پ��� �ʵ尡 ��� �ֽ��ϴ�.
%
%      trainedModel.predictFcn: �� �����͸� ����Ͽ� �����ϱ� ���� �Լ��Դϴ�.
%
%      validationRMSE: RMSE�� �����ϴ� double���Դϴ�. �ۿ����� ���� ��Ͽ� �� ��
%       �� ���� RMSE�� ǥ�õ˴ϴ�.
%
% �� �����ͷ� ���� �Ʒý�Ű���� �� �ڵ带 ����Ͻʽÿ�. ���� �ٽ� �Ʒý�Ű���� �����
% ���� ���� �����ͳ� �� �����͸� �Է� �μ� trainingData(��)�� ����Ͽ� �Լ��� ȣ���Ͻ�
% �ÿ�.
%
% ���� ���, ���� ������ ��Ʈ T(��)�� �Ʒõ� ȸ�� ���� �ٽ� �Ʒý�Ű���� ������ �Է���
% �ʽÿ�.
%   [trainedModel, validationRMSE] = trainRegressionModel(T)
%
% �� ������ T2���� ��ȯ�� 'trainedModel'��(��) ����Ͽ� �����Ϸ��� ������ ����Ͻʽ�
% ��.
%   yfit = trainedModel.predictFcn(T2)
%
% T2��(��) ��� �Ʒ� �߿� ���� �Ͱ� ������ ���� ���� ���� �����ϴ� ���̺��̾�� �մ�
% ��. ���� ������ ������ ������ �Է��Ͻʽÿ�.
%   trainedModel.HowToPredict

% MATLAB���� 2018-12-18 20:56:22�� �ڵ� ������


% ���� ������ ���� ���� ����
% �� �ڵ�� ���� �Ʒý�Ű�⿡ ������ ���·� �����͸�
% ó���մϴ�.
inputTable = trainingData;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false];

% ȸ�� �� �Ʒ�
% �� �ڵ�� ��� �� �ɼ��� �����ϰ� ���� �Ʒý�ŵ�ϴ�.
regressionGP = fitrgp(...
    predictors, ...
    response, ...
    'BasisFunction', 'constant', ...
    'KernelFunction', 'rationalquadratic', ...
    'Standardize', true);

% ���� �Լ��� ����Ͽ� ��� ����ü ����
predictorExtractionFcn = @(t) t(:, predictorNames);
gpPredictFcn = @(x) predict(regressionGP, x);
trainedModel.predictFcn = @(x) gpPredictFcn(predictorExtractionFcn(x));

% �߰����� �ʵ带 ��� ����ü�� �߰�
trainedModel.RequiredVariables = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
trainedModel.RegressionGP = regressionGP;
trainedModel.About = '�� ����ü�� ȸ�� �н��� R2018b���� ������ �Ʒõ� ���Դϴ�.';
trainedModel.HowToPredict = sprintf('�� ���̺� T�� ����Ͽ� �����Ϸ��� ������ ����Ͻʽÿ�. \n yfit = c.predictFcn(T) \n���⼭ ''c''�� �� ����ü�� ��Ÿ���� ������ �̸�(��: ''trainedModel'')���� �ٲٽʽÿ�. \n \n���̺� T�� �������� ��ȯ�� ������ �����ؾ� �մϴ�. \n c.RequiredVariables \n���� ����(��: ���/����, ��������)�� ���� �Ʒ� �����Ϳ� ��ġ�ؾ� �մϴ�. \n�߰� ������ ���õ˴ϴ�. \n \n�ڼ��� ������ <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appregression_exportmodeltoworkspace'')">How to predict using an exported model</a>��(��) �����Ͻʽÿ�.');

% ���� ������ ���� ���� ����
% �� �ڵ�� ���� �Ʒý�Ű�⿡ ������ ���·� �����͸�
% ó���մϴ�.
inputTable = trainingData;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false];

% ���� ���� ����
partitionedModel = crossval(trainedModel.RegressionGP, 'KFold', 5);

% ���� ������ ���
validationPredictions = kfoldPredict(partitionedModel);

% ���� RMSE ���
validationRMSE = sqrt(kfoldLoss(partitionedModel, 'LossFun', 'mse'));
