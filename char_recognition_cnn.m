function char_result=char_recognition_cnn(Ipchar)
load cnn_param_char.mat;
array4d=zeros(cnn_param.size(1),cnn_param.size(2),1,2);
array4d(:,:,1,1)=imresize(Ipchar,cnn_param.size);
array4d(:,:,1,2)=imresize(Ipchar,cnn_param.size);
result=char(classify(cnn_param.net,array4d))';
char_result=result(1);