function Imagek=FRcnnDetect(img,FRcnn)
    img_temp=imresize(img,FRcnn.imgsize(1:2));
    [row,col,~]=size(img);
    ky=FRcnn.imgsize(1)/row;
    kx=FRcnn.imgsize(2)/col;
    tic;
    bbox= detect(FRcnn.net,img_temp);
    v=[1/kx;1/ky;1/kx;1/ky];
    T=diag(v);
    bbox=(T*bbox')';
    bbox(3)=bbox(3)-kx+1;
    bbox(4)=bbox(4)-ky+1;
    bbox=round(bbox);
    detectedImg = insertShape(img,'Rectangle',bbox,'LineWidth',7);
    figure;imshow(detectedImg)
    etime=toc;
    fprintf(['定位车牌耗时',num2str(etime),'秒\n'])
    if size(bbox,1)==1
       up=bbox(2);down=bbox(2)+bbox(4)-1;
       left=bbox(1);right=bbox(1)+bbox(3)-1;
       Imagek= img(up:down,left:right,:);
       [~,~,~,~,k,Imagek] =mycolor(Imagek);
       if k==0
           Imagek= img(up:down,left:right,:);
       end
    else
        k=zeros(1,size(bbox,1));
        for j = 1:size(bbox,1)
           tempbbox= bbox(j,:);
           up=tempbbox(2);down=tempbbox(2)+tempbbox(4)-1;
           left=tempbbox(1);right=tempbbox(1)+tempbbox(3)-1;
           Imagek= img(up:down,left:right,:);
           [~,~,~,~,k(j),~] =mycolor(Imagek);
        end
        if sum(k)~=0
            index=k==1;
            bbox=bbox(index,:);
            up=bbox(2);down=bbox(2)+bbox(4)-1;
            left=bbox(1);right=bbox(1)+bbox(3)-1;
            Imagek= img(up:down,left:right,:);
            [~,~,~,~,~,Imagek] =mycolor(Imagek);
        end
    end
    figure;imshow(Imagek);title('车牌')