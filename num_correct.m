function [Ipcrop,newRow]=num_correct(Ipcrop,maxRow)
row=size(Ipcrop,1);
one_row=sum(Ipcrop,2);%水平投影
% figure(2);plot(one_row);title('水平投影')
up=round(row/2);
down=round(row/2);
middle=round(row/2);
%简单的自适应阈值
num=4;
thresh=min(one_row(one_row>0));
temp_row=sort(one_row(1:middle,:));
Tchar_up=sum(temp_row(end-num:end,:));
temp_row=sort(one_row(middle:end,:));
Tchar_down=sum(temp_row(end-num:end,:));

while (one_row(up)>=thresh  || sum(one_row(up:middle))<Tchar_up)   && up>1 
    up=up-1;
end
while (one_row(down)>=thresh  || sum(one_row(middle:down))<Tchar_down) && down<row
    down=down+1;
end
if nargin==2 
    while (down-up)<maxRow && up>1
        up=up-1;
    end
    Ipcrop = Ipcrop(up:down,:); 
else
    Ipcrop = Ipcrop(up:down,:); 
end
newRow = down -up +1;
% figure(1);subplot(122);imshow(Ipcrop);title('处理后')