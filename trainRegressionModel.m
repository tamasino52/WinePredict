function [trainedModel, validationRMSE] = trainRegressionModel(trainingData)
% [trainedModel, validationRMSE] = trainRegressionModel(trainingData)
% 훈련된 회귀 모델과 그 RMSE을(를) 반환합니다. 이 코드는 회귀 학습기 앱에서 훈련된 모델
% 을 다시 만듭니다. 생성된 코드를 사용하여 동일한 모델을 새 데이터로 훈련시키는 것을 자동
% 화하거나, 모델을 프로그래밍 방식으로 훈련시키는 방법을 익힐 수 있습니다.
%
%  입력값:
%      trainingData: 앱으로 가져온 것과 동일한 예측 변수와 응답 변수 열을 포함하는 테
%       이블입니다.
%
%  출력값:
%      trainedModel: 훈련된 회귀 모델이 포함된 구조체입니다. 이 구조체에는 훈련된 모
%       델에 대한 정보가 포함된 다양한 필드가 들어 있습니다.
%
%      trainedModel.predictFcn: 새 데이터를 사용하여 예측하기 위한 함수입니다.
%
%      validationRMSE: RMSE를 포함하는 double형입니다. 앱에서는 내역 목록에 각 모델
%       에 대한 RMSE가 표시됩니다.
%
% 새 데이터로 모델을 훈련시키려면 이 코드를 사용하십시오. 모델을 다시 훈련시키려면 명령줄
% 에서 원래 데이터나 새 데이터를 입력 인수 trainingData(으)로 사용하여 함수를 호출하십
% 시오.
%
% 예를 들어, 원래 데이터 세트 T(으)로 훈련된 회귀 모델을 다시 훈련시키려면 다음을 입력하
% 십시오.
%   [trainedModel, validationRMSE] = trainRegressionModel(T)
%
% 새 데이터 T2에서 반환된 'trainedModel'을(를) 사용하여 예측하려면 다음을 사용하십시
% 오.
%   yfit = trainedModel.predictFcn(T2)
%
% T2은(는) 적어도 훈련 중에 사용된 것과 동일한 예측 변수 열을 포함하는 테이블이어야 합니
% 다. 세부 정보를 보려면 다음을 입력하십시오.
%   trainedModel.HowToPredict

% MATLAB에서 2018-12-18 20:56:22에 자동 생성됨


% 예측 변수와 응답 변수 추출
% 이 코드는 모델을 훈련시키기에 적합한 형태로 데이터를
% 처리합니다.
inputTable = trainingData;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false];

% 회귀 모델 훈련
% 이 코드는 모든 모델 옵션을 지정하고 모델을 훈련시킵니다.
regressionGP = fitrgp(...
    predictors, ...
    response, ...
    'BasisFunction', 'constant', ...
    'KernelFunction', 'rationalquadratic', ...
    'Standardize', true);

% 예측 함수를 사용하여 결과 구조체 생성
predictorExtractionFcn = @(t) t(:, predictorNames);
gpPredictFcn = @(x) predict(regressionGP, x);
trainedModel.predictFcn = @(x) gpPredictFcn(predictorExtractionFcn(x));

% 추가적인 필드를 결과 구조체에 추가
trainedModel.RequiredVariables = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
trainedModel.RegressionGP = regressionGP;
trainedModel.About = '이 구조체는 회귀 학습기 R2018b에서 내보낸 훈련된 모델입니다.';
trainedModel.HowToPredict = sprintf('새 테이블 T를 사용하여 예측하려면 다음을 사용하십시오. \n yfit = c.predictFcn(T) \n여기서 ''c''를 이 구조체를 나타내는 변수의 이름(예: ''trainedModel'')으로 바꾸십시오. \n \n테이블 T는 다음에서 반환된 변수를 포함해야 합니다. \n c.RequiredVariables \n변수 형식(예: 행렬/벡터, 데이터형)은 원래 훈련 데이터와 일치해야 합니다. \n추가 변수는 무시됩니다. \n \n자세한 내용은 <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appregression_exportmodeltoworkspace'')">How to predict using an exported model</a>을(를) 참조하십시오.');

% 예측 변수와 응답 변수 추출
% 이 코드는 모델을 훈련시키기에 적합한 형태로 데이터를
% 처리합니다.
inputTable = trainingData;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false];

% 교차 검증 수행
partitionedModel = crossval(trainedModel.RegressionGP, 'KFold', 5);

% 검증 예측값 계산
validationPredictions = kfoldPredict(partitionedModel);

% 검증 RMSE 계산
validationRMSE = sqrt(kfoldLoss(partitionedModel, 'LossFun', 'mse'));
