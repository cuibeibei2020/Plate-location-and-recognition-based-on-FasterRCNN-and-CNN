function recognition(img)
%img是倾斜矫正后的图片
img=imresize(img,[140,440]);
Ipcrop=plate_segmentation(img);
Ipchar = Ipcrop{end};
tic;
num_result=num_recognition_cnn(Ipcrop);
char_result=char_recognition_cnn(Ipchar);
figure(53);imshow(img)
title([char_result,num_result],'fontsize',16)
toc