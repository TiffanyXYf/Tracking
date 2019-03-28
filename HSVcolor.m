function HIST = HSVcolor(im,centre,Hx,Hy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calaulate the HSV of an image and calculate the histgram of the pointed
% area of the image
% Author: Cuifang
% Date:2019 3 1

%ͼ��ת��
im=double(im);      % ת��Ϊ[0,1]
im=rgb2hsv(im);     % ת��Ϊhsv�ռ�

% Hx = square_size(2);%()
% Hy = square_size(1);
im_m1 = size(im,1);
im_n1 = size(im,2);


if centre(2)>Hx && centre(2)<im_n1-Hx &&centre(1)>Hy &&centre(1)<im_m1-Hy 
    H=im(centre(1)-Hy:centre(1)+Hy,centre(2)-Hx:centre(2)+Hx,1);        %hsi(:, :, 1)��ɫ�ȷ��������ķ�Χ��[0, 360]��
    S=im(centre(1)-Hy:centre(1)+Hy,centre(2)-Hx:centre(2)+Hx,2);        %hsi(:, :, 2)�Ǳ��Ͷȷ�������Χ��[0, 1]��
    V=im(centre(1)-Hy:centre(1)+Hy,centre(2)-Hx:centre(2)+Hx,3);        %hsi(:, :, 3)�����ȷ�������Χ��[0, 1]��
    [im_m,im_n] = size(H);
    H = H*360;
    for i=1:im_m%(240)
         for j=1:im_n
            if H(i,j)>=345 || H(i,j)<15
                H(i,j)=0;
            end
            if H(i,j)<25&&H(i,j)>=15
                H(i,j)=1;
            end
            if H(i,j)<45&&H(i,j)>=25
                H(i,j)=2;
            end
            if H(i,j)<55&&H(i,j)>=45
                H(i,j)=3;
            end
            if H(i,j)<80&&H(i,j)>=55
                H(i,j)=4;
            end
            if H(i,j)<108&&H(i,j)>=80
                H(i,j)=5;
            end
            if H(i,j)<140&&H(i,j)>=108
                H(i,j)=6;
            end
            if H(i,j)<165&&H(i,j)>=140
                H(i,j)=7;
            end
            if H(i,j)<190&&H(i,j)>=165
                H(i,j)=8;
            end
            if H(i,j)<220&&H(i,j)>=190
                H(i,j)=9;
            end
            if H(i,j)<255&&H(i,j)>=220
                H(i,j)=10;
            end
            if H(i,j)<275&&H(i,j)>=255
                H(i,j)=11;
            end
            if H(i,j)<290&&H(i,j)>=275
                H(i,j)=12;
            end
            if H(i,j)<316&&H(i,j)>=290
                H(i,j)=13;
            end
            if H(i,j)<330&&H(i,j)>=316
                H(i,j)=14;
            end
            if H(i,j)<345&&H(i,j)>=330
                H(i,j)=15;
            end
        end
    end 
    for i=1:im_m%(240)
         for j=1:im_n
            if S(i,j)>0 && S(i,j)<=0.15
                S(i,j)=0;
            end
            if S(i,j)<=0.4&&S(i,j)>0.15
                S(i,j)=1;
            end
            if S(i,j)<=0.75&&S(i,j)>0.4
                S(i,j)=2;
            end
            if S(i,j)<=1&&S(i,j)>0.75
                S(i,j)=3;
            end
        end
     end

     %����V����
     for i=1:im_m%(240)
         for j=1:im_n
            if V(i,j)>0 && V(i,j)<=0.15
                V(i,j)=0;
            end
            if V(i,j)<=0.4&&V(i,j)>0.15
                V(i,j)=1;
            end
            if V(i,j)<=0.75&&V(i,j)>0.4
                V(i,j)=2;
            end
            if V(i,j)<=1&&V(i,j)>0.75
                V(i,j)=3;
            end
        end
     end
     %%
     G=zeros(im_m,im_n);     % ���ÿһ�����ص���ɫ�ȼ�����
     for i=1:im_m%(240)
         for j=1:im_n%(360)
             G(i,j)=H(i,j)*16+S(i,j)*4+V(i,j);
         end
     end

     %centre=[(1+hn)/2 (1+hm)/2];   % ͼ������ĵ�
     im_n2=round(im_n/2);im_m2=round(im_m/2);              % ����뾶)
     centre2 = [im_n2,im_m2];
     h=sqrt(im_n2^2+im_m2^2); 
     m=256;
     p=zeros(m,1);
    for u=1:m
        s1=0;
        s2=0;
        for i=1:im_m%(240)
            for j=1:im_n%(360)
                temp_x=j;temp_y=i;     % ���ص������
                distance=sqrt((centre2(2)-temp_x)^2+(centre2(1)-temp_y)^2);    % ���ص�������ĵ�ľ���
                r=distance/h;
                % ��������ص��Ȩ��
                if(r<1)       
                    k=1-r^2;
                else
                    k=0;
                end
                % �ж���ɫ�����Ƿ���u
                if(G(i,j)==u)
                    delta=1;
                else
                    delta=0;
                end
                s1=s1+k*delta;
                s2=s2+k;
            end
        end
        p(u)=s1/s2;
    end
    HIST = p; 
else
    HIST = 0;    
end








% 
% I = (centre(2)>=1 & centre(2)<=im_n);
% J = (centre(1)>=1 & centre(1)<=im_m);
% if I && J %�Ϸ������ڼ��������ڵ���ɫֱ��ͼ
%   %����H����  
% for i=1:im_m
%     for j=1:im_n
%         if H(i,j)>=345 || H(i,j)<15
%             H(i,j)=0;
%         end
%         if H(i,j)<25&&H(i,j)>=15
%             H(i,j)=1;
%         end
%         if H(i,j)<45&&H(i,j)>=25
%             H(i,j)=2;
%         end
%         if H(i,j)<55&&H(i,j)>=45
%             H(i,j)=3;
%         end
%         if H(i,j)<80&&H(i,j)>=55
%             H(i,j)=4;
%         end
%         if H(i,j)<108&&H(i,j)>=80
%             H(i,j)=5;
%         end
%         if H(i,j)<140&&H(i,j)>=108
%             H(i,j)=6;
%         end
%         if H(i,j)<165&&H(i,j)>=140
%             H(i,j)=7;
%         end
%         if H(i,j)<190&&H(i,j)>=165
%             H(i,j)=8;
%         end
%         if H(i,j)<220&&H(i,j)>=190
%             H(i,j)=9;
%         end
%         if H(i,j)<255&&H(i,j)>=220
%             H(i,j)=10;
%         end
%         if H(i,j)<275&&H(i,j)>=255
%             H(i,j)=11;
%         end
%         if H(i,j)<290&&H(i,j)>=275
%             H(i,j)=12;
%         end
%         if H(i,j)<316&&H(i,j)>=290
%             H(i,j)=13;
%         end
%         if H(i,j)<330&&H(i,j)>=316
%             H(i,j)=14;
%         end
%         if H(i,j)<345&&H(i,j)>=330
%             H(i,j)=15;
%         end
%     end
% end
% 
%  %����S����
%  for i=1:im_m
%     for j=1:im_n
%         if S(i,j)>0 && S(i,j)<=0.15
%             S(i,j)=0;
%         end
%         if S(i,j)<=0.4&&S(i,j)>0.15
%             S(i,j)=1;
%         end
%         if S(i,j)<=0.75&&S(i,j)>0.4
%             S(i,j)=2;
%         end
%         if S(i,j)<=1&&S(i,j)>0.75
%             S(i,j)=3;
%         end
%     end
%  end
%  
%  %����V����
%  for i=1:im_m
%     for j=1:im_n
%         if V(i,j)>0 && V(i,j)<=0.15
%             V(i,j)=0;
%         end
%         if V(i,j)<=0.4&&V(i,j)>0.15
%             V(i,j)=1;
%         end
%         if V(i,j)<=0.75&&V(i,j)>0.4
%             V(i,j)=2;
%         end
%         if V(i,j)<=1&&V(i,j)>0.75
%             V(i,j)=3;
%         end
%     end
%  end
% %% ������ɫֱ��ͼ���������������ͼƬ����ɫֱ��ͼ
% G=zeros(im_m,im_n);     % ���ÿһ�����ص���ɫ�ȼ�����
%  for i=1:im_m%(240)
%      for j=1:im_n%(360)
%          G(i,j)=H(i,j)*16+S(i,j)*4+V(i,j);
%      end
%  end
%  
%  %centre=[(1+hn)/2 (1+hm)/2];   % ͼ������ĵ�
%  im_n=im_n/2;im_m=im_m/2;              % ����뾶
%  h=sqrt(im_n^2+im_m^2); 
%  m=256;
%  p=zeros(m,1);
% for u=1:m
%     s1=0;
%     s2=0;
%     for i=1:im_m%(240)centre=[240,360]
%         for j=1:im_n%(360)
%             temp_x=j;temp_y=i;     % ���ص������
%             distance=sqrt((centre(2)-temp_x)^2+(centre(1)-temp_y)^2);    % ���ص�������ĵ�ľ���
%             r=distance/h;
%             % ��������ص��Ȩ��
%             if(r<1)       
%                 k=1-r^2;
%             else
%                 k=0;
%             end
%             % �ж���ɫ�����Ƿ���u
%             if(G(i,j)==u)
%                 delta=1;
%             else
%                 delta=0;
%             end
%             s1=s1+k*delta;
%             s2=s2+k;
%         end
%     end
%     p(u)=s1/s2;
% end
% HIST=p;
% else
%     HIST = 1000*ones(256,1);
% end    




% %��hsv�ռ�ǵȼ��������
% %  h������16����
% %  s������4����
% %  v������4����
% 
% %����H����
% % im_m = square_size(1);%(240)
% % im_n = square_size(2);%(360)
% H = H*360;
% for i=1:im_m
%     for j=1:im_n
%         if H(i,j)>=345 || H(i,j)<15
%             H(i,j)=0;
%         end
%         if H(i,j)<25&&H(i,j)>=15
%             H(i,j)=1;
%         end
%         if H(i,j)<45&&H(i,j)>=25
%             H(i,j)=2;
%         end
%         if H(i,j)<55&&H(i,j)>=45
%             H(i,j)=3;
%         end
%         if H(i,j)<80&&H(i,j)>=55
%             H(i,j)=4;
%         end
%         if H(i,j)<108&&H(i,j)>=80
%             H(i,j)=5;
%         end
%         if H(i,j)<140&&H(i,j)>=108
%             H(i,j)=6;
%         end
%         if H(i,j)<165&&H(i,j)>=140
%             H(i,j)=7;
%         end
%         if H(i,j)<190&&H(i,j)>=165
%             H(i,j)=8;
%         end
%         if H(i,j)<220&&H(i,j)>=190
%             H(i,j)=9;
%         end
%         if H(i,j)<255&&H(i,j)>=220
%             H(i,j)=10;
%         end
%         if H(i,j)<275&&H(i,j)>=255
%             H(i,j)=11;
%         end
%         if H(i,j)<290&&H(i,j)>=275
%             H(i,j)=12;
%         end
%         if H(i,j)<316&&H(i,j)>=290
%             H(i,j)=13;
%         end
%         if H(i,j)<330&&H(i,j)>=316
%             H(i,j)=14;
%         end
%         if H(i,j)<345&&H(i,j)>=330
%             H(i,j)=15;
%         end
%     end
% end
% 
%  %����S����
%  for i=1:im_m
%     for j=1:im_n
%         if S(i,j)>0 && S(i,j)<=0.15
%             S(i,j)=0;
%         end
%         if S(i,j)<=0.4&&S(i,j)>0.15
%             S(i,j)=1;
%         end
%         if S(i,j)<=0.75&&S(i,j)>0.4
%             S(i,j)=2;
%         end
%         if S(i,j)<=1&&S(i,j)>0.75
%             S(i,j)=3;
%         end
%     end
%  end
%  
%  %����V����
%  for i=1:im_m
%     for j=1:im_n
%         if V(i,j)>0 && V(i,j)<=0.15
%             V(i,j)=0;
%         end
%         if V(i,j)<=0.4&&V(i,j)>0.15
%             V(i,j)=1;
%         end
%         if V(i,j)<=0.75&&V(i,j)>0.4
%             V(i,j)=2;
%         end
%         if V(i,j)<=1&&V(i,j)>0.75
%             V(i,j)=3;
%         end
%     end
%  end
% %% ������ɫֱ��ͼ
% G=zeros(im_m,im_n);     % ���ÿһ�����ص���ɫ�ȼ�����
%  for i=1:im_m
%      for j=1:im_n
%          G(i,j)=H(i,j)*16+S(i,j)*4+V(i,j);
%      end
%  end
%  
%  %centre=[(1+hn)/2 (1+hm)/2];   % ͼ������ĵ�
%  im_n=im_n/2;im_m=im_m/2;              % ����뾶
%  h=sqrt(im_n^2+im_m^2); 
%  m=256;
%  p=zeros(m,1);
% for u=1:m
%     s1=0;
%     s2=0;
%     for i=1:im_m
%         for j=1:im_n
%             temp_x=j;temp_y=i;     % ���ص������
%             distance=sqrt((centre(1)-temp_x)^2+(centre(2)-temp_y)^2);    % ���ص�������ĵ�ľ���
%             r=distance/h;
%             % ��������ص��Ȩ��
%             if(r<1)       
%                 k=1-r^2;
%             else
%                 k=0;
%             end
%             % �ж���ɫ�����Ƿ���u
%             if(G(i,j)==u)
%                 delta=1;
%             else
%                 delta=0;
%             end
%             s1=s1+k*delta;
%             s2=s2+k;
%         end
%     end
%     p(u)=s1/s2;
% end
% HIST=p; 
 
 

  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 