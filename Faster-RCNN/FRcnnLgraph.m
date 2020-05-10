function lgraph=FRcnnLgraph(imgsize,anchorBoxes)
%% 搭建网络
net=resnet50;
lgraph = layerGraph(net);
imputLayer=imageInputLayer(imgsize,'Name','imageData');
lgraph=replaceLayer(lgraph,'input_1',imputLayer);
%处理avg_pool 输入大小不匹配问题
NewAvgPool = averagePooling2dLayer(2,'Name','avg_pool','stride',2);
lgraph=replaceLayer(lgraph,'avg_pool',NewAvgPool);
% 去掉后三层网络
layersToRemove = {
    'fc1000'
    'fc1000_softmax'
    'ClassificationLayer_fc1000'
    };
lgraph = removeLayers(lgraph,layersToRemove);
numClasses = 1;
numClassesPlusBackground = numClasses +1;
%定义新的classification层
newlayers = [
    fullyConnectedLayer(numClassesPlusBackground,'Name','rcnnFC')
    softmaxLayer('Name','rcnnSoftmax')
    classificationLayer('Name','rcnnClassification')
    ];
lgraph = addLayers(lgraph,newlayers);
lgraph = connectLayers(lgraph,'avg_pool','rcnnFC');
%定义全连接层的输出
numOutputs = 4*numClasses;%输出矩形框的四个参数
%定义 boxRegress layer
boxRegressionLayers = [
    fullyConnectedLayer(numOutputs,'Name','rcnnBoxFC')
    rcnnBoxRegressionLayer('Name','rcnnBoxDeltas')
    ];
lgraph = addLayers(lgraph,boxRegressionLayers);
lgraph = connectLayers(lgraph,'avg_pool','rcnnBoxFC');
%选择特征提取层
featureExtractionLayer = 'activation_40_relu';
% Disconnect the layers attached to the selected feature extraction layer.
lgraph = disconnectLayers(lgraph, featureExtractionLayer,'res5a_branch2a');
lgraph = disconnectLayers(lgraph, featureExtractionLayer,'res5a_branch1');
% Add ROI max pooling layer.
outputSize = [6 8];
roiPool = roiMaxPooling2dLayer(outputSize,'Name','roiPool');
lgraph = addLayers(lgraph, roiPool);
% Connect feature extraction layer to ROI max pooling layer.
lgraph = connectLayers(lgraph, featureExtractionLayer,'roiPool/in');
% Connect the output of ROI max pool to the disconnected layers from above.
lgraph = connectLayers(lgraph, 'roiPool','res5a_branch2a');
lgraph = connectLayers(lgraph, 'roiPool','res5a_branch1');
% 搭建 RPN,连接到特征提取层
%anchorBoxes
proposalLayer=regionProposalLayer(anchorBoxes,'Name','regionProposal');
lgraph = addLayers(lgraph, proposalLayer);
numAnchors = size(anchorBoxes,1);
numFilters = 256;
rpnLayers = [
    convolution2dLayer(3,numFilters,'padding',[1,1],'Name','rpnConv3x3')
    reluLayer('Name','rpnRelu')
    ];
lgraph = addLayers(lgraph, rpnLayers);
lgraph = connectLayers(lgraph, featureExtractionLayer, 'rpnConv3x3');
%添加RPN分类输出层 输出背景分、前景分
rpnClsLayers = [
   convolution2dLayer(1,numAnchors*2,'Name','rpnConv1x1ClsScores') 
   rpnSoftmaxLayer('Name','rpnSoftmax')
   rpnClassificationLayer('Name','rpnClassifiction')
];
lgraph = addLayers(lgraph, rpnClsLayers);
lgraph = connectLayers(lgraph, 'rpnRelu', 'rpnConv1x1ClsScores');
%添加RPN回归层
rpnRegLayers = [
    convolution2dLayer(1,numAnchors*4,'Name','rpnConv1x1BoxDeltas')
    rcnnBoxRegressionLayer('Name','rpnBoxDeltas')
];
lgraph = addLayers(lgraph, rpnRegLayers);
lgraph = connectLayers(lgraph, 'rpnRelu', 'rpnConv1x1BoxDeltas');
%最后，将分类和回归特征映射连接到区域建议层输入，将 ROI 汇集层连接到区域建议层输出
lgraph = connectLayers(lgraph, 'rpnConv1x1ClsScores', 'regionProposal/scores');
lgraph = connectLayers(lgraph, 'rpnConv1x1BoxDeltas', 'regionProposal/boxDeltas');
lgraph = connectLayers(lgraph, 'regionProposal', 'roiPool/roi');

