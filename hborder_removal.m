function img_bw=hborder_removal(img_bw)
diff_row=diff(img_bw,1,2);% 前一列减后一列
diff_row_sum = sum(abs(diff_row), 2);  %每行图像变化的丰富度
% figure(3);plot(diff_row_sum);title('水平变化丰富度')
[row,~]=size(img_bw);
row_down=round(1*row/2);
row_up=round(1*row/2);
while row_up >1
    if diff_row_sum(row_up)<10 %如何自适应话阈值？
        break;
    else
        row_up=row_up-1;
    end
end
while row_down <row
    if diff_row_sum(row_down)<10
        break;
    else
        row_down=row_down+1;
    end
end
img_bw=img_bw(row_up:row_down,:);