function net=net_init_t1(looperEngine)


% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize =looperEngine.net.hiddenLayerSize;
net = patternnet(hiddenLayerSize, trainFcn);
%net = lvqnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = looperEngine.net.trainRatio;
net.divideParam.valRatio = looperEngine.net.valRatio;
net.divideParam.testRatio =looperEngine.net.testRatio;

net.trainParam.epochs = looperEngine.net.trainParam.epochs;
net.trainParam.goal = looperEngine.net.trainParam.goal;
net.trainParam.min_grad = looperEngine.net.trainParam.min_grad;
net.trainParam.max_fail = looperEngine.net.trainParam.max_fail;
net.trainParam.Sigma=looperEngine.net.trainParam.Sigma;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'crossentropy';  % Cross-Entropy

%net.layerConnect=[0 1;1 0];

%net.layers{1}.transferFcn='poslin';

%net.layers{2}.transferFcn='radbasn';
%net.layers{2}.transferFcn='tribas';
end