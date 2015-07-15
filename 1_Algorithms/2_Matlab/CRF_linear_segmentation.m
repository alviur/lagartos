%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% trainSeqs=rgb;
% trainLabels=intensidad;
% testSeqs=trainSeqs;
% testLabels=trainLabels;

%load sampleData;

paramsData.weightsPerSequence = ones(1,128);
paramsData.factorSeqWeights = 1;

paramsNodCRF.normalizeWeights = 1;
R{1}.params = paramsNodCRF;
[R{1}.model R{1}.stats] = train(trainSeqs, trainLabels, R{1}.params);
[R{1}.ll R{1}.labels] = test(R{1}.model, testSeqs, testLabels);
