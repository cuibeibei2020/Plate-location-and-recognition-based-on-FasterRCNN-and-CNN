function img_bw=plate_correct(img_bw)
img_bw=hborder_removal(img_bw);
theta=0:179;
R=radon(img_bw,theta);
R1=max(R);
[~,theta_max]=max(R1);
theta_max=90-theta_max;
img_bw=imrotate(img_bw,theta_max,'bilinear','crop');