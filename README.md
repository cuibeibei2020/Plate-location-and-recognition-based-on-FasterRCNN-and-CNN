# Plate-location-and-recognition-based-on-FasterRCNN-and-CNN
电子科技大学，信通学院，综合课程设计<br>
针对不同的情况，本文综合运用了HSV色彩空间、边缘检测以及Faster-RCNN神经网络等工具，实现了对车牌的定位。利用两个卷积神经网络CNN完成对字符的识别。附带了车牌识别相关数据集，由于文件较大请移步：<br>[百度云链接](https://pan.baidu.com/s/1ugnH5fGQ1ZP2Kyft65wngw)  提取码：shdo<br>
# FasterRCNN实现车牌定位
Faster-RCNN是一种建立在Fast-RCNN基础之上的网络，其克服了后者检测耗时长的缺点，将候选区域生成、分类检测集成在同一个网络之中，实现了端到端的训练。Faster-RCNN的结构主要分为三大部分，第一部分是共享卷积层用于生成共享特征图；第二部分是候选区域生成网络RPN；第三部分是对候选区域进行分类的网络Classifier。如图：![FasterRCNN](./Faster-RCNN/img/FRCNN.jpg)
