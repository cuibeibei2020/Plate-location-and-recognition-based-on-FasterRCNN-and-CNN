function Ipcrop=plate_segmentation(img)
% [filename,pathname]=uigetfile({'*.jpg'});
% global FILENAME   %定义全局变量
% FILENAME=[pathname filename];
% img=imread(FILENAME);
img=imresize(img,[140,440]);
figure(50);imshow(img);title('处理前')
Ipbw=border_removal(img);
Ippcrop=double(Ipbw);
figure(51);imshow(Ippcrop);title('处理后')
[~,col]=size(Ippcrop);
one_col = sum(Ippcrop);
interval={331:440,222:330,111:220,1:110};
temp_thresh=zeros(1,4);
temp_col=sort(one_col);
for i=1:4
    temp_col=sort(one_col(interval{i}));
    temp_thresh(i)=temp_col(19);
end
thresh = round(mean(temp_thresh)); %简单的自适应阈值
thresh_char=sum(temp_col(end-7:end))+thresh*20;%简单的自适应字符像素点阈值
Ipcrop=cell(1,7);
head=col;%字符的左侧限
tail=col;%字符右侧限制
temph=col;%用于计算字符间隔
heigh = zeros(1,6);%记录数字字母高度，用于修正汉字高度
width=50;%字符宽度
j=1;
flag=false;
sum_char=zeros(1,7);
while j <=7
    if head < 1  || tail < 1
        break
    end
    while one_col(1,tail)<=thresh && tail>1
         tail=tail-1;
    end
    head=tail;
    while one_col(1,head)>thresh && head>1 && (tail-head)<1.1*width
         head=head-1;
    end
    
    if j<7 %J小于7说明不是汉字
        while (tail-head)<width && tail < col  &&(tail+1)<=temph && head>1 && one_col(1,head)<=thresh  %防止粘上别的字符
            tail=tail+1;
            head=head-1;
        end
    else
        while (tail-head)<width-3 && head>1 %汉字特殊，中间可能会有空隙
            head=head-1;%对于川字tail不能向后退
        end
        tail=tail+3;
    end
    if  sum(one_col(1,head:tail))>thresh_char%像素点数满足要求的就认为是一个字符;
        flag=true;
    end
    if flag  
        if (tail-head)<width
            temp_n=round((50-(tail-head))/2);
            padding=false(140,temp_n);
            temp_img=[padding,Ipbw(:,head:tail),padding];
        else
            temp_img=Ipbw(:,head:tail);
        end
        if j<7
            [temp_img,heigh(j)]=num_correct(temp_img);
        else
           meanRow=mean(heigh);
            [temp_img,~]=num_correct(temp_img,meanRow);
        end
        Ipcrop{j}=temp_img;
        figure(8); subplot(1,7,j); imshow(Ipcrop{j})
        sum_char(1,j)=sum(one_col(head:tail));
        j=j+1;
        flag=false;
        tail=head;
        temph=head;
    else
        tail=head;%如果不满足字符像素阈值则说明是干扰，排除之
    end
end
