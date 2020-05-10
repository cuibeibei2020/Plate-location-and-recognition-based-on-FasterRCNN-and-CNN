%% cnn_example
clear 
close all
clc
%% 导入数据
% digitDatasetPath = fullfile('D:\腾讯\Tencent Files\综合课设\车牌识别代码\识别code\train_num\testset_28_28\');
% imags = imageDatastore(digitDatasetPath, ...
%     'IncludeSubfolders',true,'LabelSource','foldernames');% 采用文件夹名称作为数据标记
% % digitDatasetPath = fullfile('D:\腾讯\Tencent Files\综合课设\车牌识别代码\识别code\train_num\myDataset\');
% % imags = imageDatastore(digitDatasetPath, ...
% %     'IncludeSubfolders',true,'LabelSource','foldernames');% 采用文件夹名称作为数据标记
train_path='D:\腾讯\Tencent Files\综合课设\车牌识别代码\together\together\togetherv3.5\mydataset\';
test_path='D:\腾讯\Tencent Files\综合课设\车牌识别代码\识别code\train_num\testset_28_28\';
load cnn_param.mat
%% 制作训练集与测试集与验证集
[images_train ,labels_train]=myplateData(train_path,1);
[images_test,labels_test]=myplateData(test_path,1);
% img=images_train(:,:,1,1);
% cnn_param.size=size(img);
%% 定义卷积神经网络结构
% layers = [
%     %输入层
%     imageInputLayer([cnn_param.size,1]);
%     %conv1 卷积层1
%     convolution2dLayer(5,16,'Padding','same')
%     batchNormalizationLayer
%     reluLayer %激活函数层
%     
%     %maxpooling 最大池化层
%     maxPooling2dLayer(2,'stride',2)
%     
%     %conv2 卷积层2
%     convolution2dLayer(5,32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer %激活函数层
%     
%     %maxpooling 最大池化层
%     maxPooling2dLayer(2,'stride',2)
%     
%     convolution2dLayer(5, 64)
%     batchNormalizationLayer
%     reluLayer
%     
%     %全连接层
%     fullyConnectedLayer(34)
%     softmaxLayer
%     classificationLayer];

%% 设置训练参数
options=trainingOptions('sgdm', ...
    'MaxEpochs',300,...%计算轮数 对全部数据进行一次完整的训练称为“一代”
    'InitialLearnRate',1e-4, ...%学习速率
    'MiniBatchsize',60,...%一次读取60张图片 使用一小部分数据经行训练反向传播修改参数称为“一批”
    'ExecutionEnvironment','gpu');
%     'ValidationData', [], ...%iteration：对一批图片进行一次训练的过程称为“一次训练”
%     'ValidationFrequency',50,...
%% 训练网络
% cnn_param.net = trainNetwork(images_train ,labels_train, layers ,options);
cnn_param.net = trainNetwork(images_train ,labels_train,cnn_param.net.Layers ,options);
%在已训练网络的基础上继续训练
%% 测试网络
test_result=classify(cnn_param.net,images_test);
accuracy = sum(test_result==labels_test)/size(labels_test,1);
cnn_param.accuracy=accuracy;
disp(['测试集合识别正确率：',num2str(accuracy)])
save 'D:\腾讯\Tencent Files\综合课设\车牌识别代码\识别code\train_num\cnn_param_temp.mat' cnn_param