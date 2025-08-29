clear;close all;clc; tic;

addpath(genpath('./'));

%% load datasets
% load('HW.mat'); lambda_1=1e-2;K=510;
% load('UCI.mat');lambda_1=1e-2;K=710;
 load('MSRC-v1.mat'); lambda_1=10; K=50;
   
num_views = length(X);%The number of views
numCluster = length(unique(truth));%The number of classes
nSmp = length(truth);%The number of samples
%% Add noise to data
%Noise intensity: 0 indicates no noise, and 0.10 indicates different degrees of Gaussian noise (standard deviation).
noise_levels = 0;
%noise_levels = 0.10; %noise_levels belong to[0.01; 0.05; 0.10; 0.15]
if noise_levels == 0
    X = X;
else
    rate = noise_levels;  % Current noise standard deviation
    fprintf('===== Noise intensity: %.2f =====\n', rate);
    %% Noise style
    style = "Gaussian";
    % style ="Rayleigh";
    X = add_noise(X,rate,style);
end
%% Run it 5 times and take the average
iter = 5 ;
t1=clock;
for i=1:iter
  
    [Z,F_views] = MVCLG(X,num_views,numCluster,nSmp,lambda_1,K);
%%  Spectral clustering
    Y = spectralcluster(Z,numCluster);

    result=allClusteringMeasure(truth, Y);
    tempACC(i) = result(1);
    tempNMI(i) = result(2);
    tempPurity(i) = result(3);
    tempARI(i) = result(4);
    tempFscore(i) = result(5);
    tempPrecision(i) = result(6);
    tempRecall(i) = result(7);

end


ACC = [mean(tempACC),std(tempACC)];
NMI = [mean(tempNMI),std(tempNMI)];
Purity = [mean(tempPurity),std(tempPurity)];
ARI = [mean(tempARI),std(tempARI)];
Fscore = [mean(tempFscore),std(tempFscore)];
Precision = [mean(tempPrecision),std(tempPrecision)];
Recall = [mean(tempRecall),std(tempRecall)];
t2 = clock;
Time = etime(t2,t1)/iter;

ACC = roundn(ACC,-4)
NMI = roundn(NMI,-4)
Purity = roundn(Purity,-4)
ARI = roundn(ARI,-4)
Fscore =roundn(Fscore,-4)
Precision =roundn(Precision,-4)
Recall =roundn(Recall,-4)
Time = roundn(Time,-4)

        


