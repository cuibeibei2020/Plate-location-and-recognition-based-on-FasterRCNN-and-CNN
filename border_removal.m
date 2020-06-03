function img_temp=border_removal(img)
% % % img=imread('D:\腾讯\Tencent Files\综合课设\车牌识别代码\分割code\380EA3.jpg');

% img=imread('D:\腾讯\Tencent Files\综合课设\车牌识别代码\分割code\380EA4.jpg');
% img=blue_cut(img);
if length(size(img)) == 3
    img_gray=rgb2gray(img);
else
    img_gray=img;
end
img_gray=imresize(img_gray,[140,440]);
T=graythresh(img_gray);
img_bw=imbinarize(img_gray,T);
figure(2);imshow(img_bw);title('二值化')
% %% 去除上下边框和铆钉
% %假设水平边框水平方向变化不丰富
% %统计跳变次数——水平方向变化丰富度
% diff_row=diff(img_bw,1,2);% 前一列减后一列
% diff_row_sum = sum(abs(diff_row), 2);  %每行图像变化的丰富度
% figure(3);plot(diff_row_sum);title('水平变化丰富度')
% [row,col]=size(img_bw);
% %求阈值
% 
% row_down=round(1*row/3);
% row_up=round(2*row/3);
% while row_up >1
%     if diff_row_sum(row_up)<10 %如何自适应话阈值？
%         break;
%     else
%         row_up=row_up-1;
%     end
% end
% while row_down <row
%     if diff_row_sum(row_down)<10
%         break;
%     else
%         row_down=row_down+1;
%     end
% end
% %% 废
% % [row,col]=size(img_bw);
% % flag_row=false;
% % while ~flag_row
% %     [~,row_max]=max(diff_row_sum);
% %     row_down=row_max;
% %     row_up=row_max;
% %     while row_up >1
% %         if diff_row_sum(row_up)<10 %如何自适应话阈值？
% %             break;
% %         else
% %             row_up=row_up-1;
% %         end
% %     end
% %     while row_down <row
% %         if diff_row_sum(row_down)<10
% %             break;
% %         else
% %             row_down=row_down+1;
% %         end
% %     end
% %     if row_down-row_up<50
% %         diff_row_sum(row_max)=0;%存在变化最丰富的行在车牌两侧
% %         flag_row=false;
% %     else
% %         flag_row=true;%确实切割掉了上下边框
% %     end
% % end
img_temp=hborder_removal(img_bw);
%figure(3);imshow(img_bw);title('旋转矫正')
%figure(4);imshow(img_temp);title('去除上下边框')
%% 去除两侧黑色背景
[row,col]=size(img_temp);
one_col=zeros(1,col);
for j = 1: col
    for i = 1:row
        if img_temp(i,j)==1
            one_col(1,j)=one_col(1,j)+1;
        end
    end
end
% figure(5);plot(one_col);title('竖直投影')
col_left=round(col/2);
col_right=round(col/2);
min_col=min(one_col);
temp_col=sort(one_col);
thresh_char=sum(temp_col(end-1:end)); %简单的字符像素点数阈值
while one_col(col_left)>min_col || sum(one_col(1:col_left))>thresh_char
    if col_left == 1
        break;
    else
        col_left=col_left-1;
    end
end
while one_col(col_right)>min_col || sum(one_col(col_right:end))>thresh_char
    if col_right == col
        break;
    else
        col_right=col_right+1;
    end
end
img_temp=img_temp(:,col_left:col_right);
img_temp=imresize(img_temp,[140,440]);
%figure(6);imshow(img_temp);title('处理后')
% figure(4);imshow(img_temp);title('去除上下边框和铆钉')


