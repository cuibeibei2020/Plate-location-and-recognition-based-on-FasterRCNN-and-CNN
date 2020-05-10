function result=num_recognition_cnn(Ipcrop)
load cnn_param.mat
n=length(Ipcrop)-1;
array4d=zeros(cnn_param.size(1),cnn_param.size(2),1,n);
for i = 1:n
    
    array4d(:,:,:,i)=imresize(Ipcrop{n+1-i},cnn_param.size);
end
result=char(classify(cnn_param.net,array4d))';
result=[result(1),'¡¤',result(2:end)];
clear cnn_param