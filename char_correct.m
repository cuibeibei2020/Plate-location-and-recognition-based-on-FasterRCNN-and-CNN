function Ipchar=char_correct(Ipchar)
img_edg=edge(Ipchar, 'canny');
theta=0:179;
R=radon(img_edg,theta);%从算法实现上讲，当theta超过90度时，即yp轴转到了第三象限，与yp轴转到第一象限等效
R1=max(R);
[~,theta_max]=find(R>=max(R1));
if theta_max <= 10 %默认原图像不可能超过10度因为之前程序已经经行过倾斜矫正了
    theta_max=-theta_max;%yp轴在第二象限，即图像向第二象限歪，此时应该顺时针旋转相应的theta角
    Ipchar=imrotate(Ipchar,theta_max,'bilinear','crop');
elseif theta_max>=169
    theta_max=180-theta_max;%图像向第一象限歪，应该顺时针旋转180-theta
    Ipchar=imrotate(Ipchar,theta_max,'bilinear','crop');
end

