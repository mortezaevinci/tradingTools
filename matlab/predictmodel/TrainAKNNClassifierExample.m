%% Train _k_-Nearest Neighbor Classifier
% Train a _k_-nearest neighbor classifier for Fisher's iris data, where _k_, 
% the number of nearest neighbors in the predictors, is 5.
% 
% Load Fisher's iris data.

load fisheriris
X = meas;
yt = species;

Y=zeros(size(yt));

for i=1:numel(yt)
    if (strcmp(yt{i},'virginica'))
        Y(i)=3;
    end
     if (strcmp(yt{i},'versicolor'))
        Y(i)=2;
     end
     if (strcmp(yt{i},'setosa'))
        Y(i)=1;
    end
end

%% 
% |X| is a numeric matrix that contains four petal measurements for 150 irises. 
% |Y| is a cell array of character vectors that contains the corresponding iris 
% species.
%% 
% Train a 5-nearest neighbor classifier. Standardize the noncategorical predictor 
% data.

Mdl = fitcknn(X,Y,'NumNeighbors',5,'Standardize',1)
%% 
% |Mdl| is a trained |ClassificationKNN| classifier, and some of its properties 
% appear in the Command Window.
%% 
% To access the properties of |Mdl|, use dot notation.

Mdl.ClassNames
Mdl.Prior
%% 
% |Mdl.Prior| contains the class prior probabilities, which you can specify 
% using the |'Prior'| name-value pair argument in |fitcknn|. The order of the 
% class prior probabilities corresponds to the order of the classes in |Mdl.ClassNames|. 
% By default, the prior probabilities are the respective relative frequencies 
% of the classes in the data.
%% 
% You can also reset the prior probabilities after training. For example, set 
% the prior probabilities to 0.5, 0.2, and 0.3, respectively.

Mdl.Prior = [0.5 0.2 0.3];
%% 
% You can pass |Mdl| to <docid:stats_ug.bs85nou predict> to label new measurements 
% or <docid:stats_ug.bs85m95 crossval> to cross-validate the classifier.
% 
% _Copyright 2012 The MathWorks, Inc._


yp=predict(Mdl,X);

error=sum(abs(yp-Y))/size(Y,1)