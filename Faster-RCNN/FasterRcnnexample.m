% function FasterRcnnexample
clear 
clc
%% 加载数据集
load plateData640seq6.mat
load FRcnn480.mat
%% 搭建网络
% net=resnet50;
% net=net.Layers(2:end-2);
% lastlayers = [
% fullyConnectedLayer(2,'Name','fc8','WeightLearnRateFactor',1, 'BiasLearnRateFactor',1)
% softmaxLayer('Name','softmax')
% classificationLayer('Name','classification')
% ];
FRcnn.imgsize=[480,640,3];
% anchorBoxes=[18,48; 36,96; 72,192; 144,384; 288,768; 576,1536];
% lgraph=FRcnnLgraph(FRcnn.imgsize,anchorBoxes);
lgraph=layerGraph(FRcnn.net.Network);
% anchorBoxes=[25,61; 50,122; 100,244; 200,488; 400,976; 800,1952];
% proposalLayer=regionProposalLayer(anchorBoxes,'Name','regionProposal');
% lgraph=replaceLayer(lgraph,'regionProposal',proposalLayer);
%% 设置训练参数,
options = trainingOptions('sgdm', ...
     'MiniBatchSize', 3, ...
     'InitialLearnRate', 1e-4, ...
     'VerboseFrequency', 480, ...
     'MaxEpochs', 20);
tic
 net = trainFasterRCNNObjectDetector(plateData640seq6,lgraph, options, ...
 'NegativeOverlapRange', [0 0.3], ...
 'PositiveOverlapRange',[0.6 1]);
FRcnn.net=net;
save 'D:\腾讯\Tencent Files\综合课设\车牌识别代码\定位code\FRcnn480.mat' FRcnn
toc
% system('shutdown -s');