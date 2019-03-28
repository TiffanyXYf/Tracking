function q_u=rgbPDF(image,center,w_halfsize) 
% ************************************************************************* 
%  
% 功能: 计算目标直方图 
% 参数:  
%       image  第一帧图像 
%       center 目标窗口的中心 
%       w_halfsize 目标窗口的带宽即半高和半宽  
%    
% 返回值: 
%       q_u: 跟踪目标的特征向量 
% 
% ***************************** end *************************************** 
 
sum_q=0; 
histo=zeros(16,16,16); 
% 计算目标窗口的位置 
rmin=center(1)-w_halfsize(1); 
rmax=center(1)+w_halfsize(1); 
cmin=center(2)-w_halfsize(2); 
cmax=center(2)+w_halfsize(2); 
 
% 目标窗口到中心的最大距离 
wmax=(rmin-center(1)).^2+(cmin-center(2)).^2+0.001; 
for i=rmin:rmax  % 计算其特征向量空间 
    for j=cmin:cmax 
        d=(i-center(1)).^2+(j-center(2)).^2; 
        w=wmax-d;  % 距离越大，权值越小 
        R=floor(image(i,j,1)/16)+1; 
        G=floor(image(i,j,2)/16)+1; 
        B=floor(image(i,j,3)/16)+1; 
        histo(R,G,B)=histo(R,G,B)+w;         
    end 
end 
 
for i=1:16 
    for j=1:16 
        for k=1:16 
            index=(i-1)*256+(j-1)*16+k;             
            q_u(index)=histo(i,j,k); 
            sum_q=sum_q+q_u(index); 
        end 
    end 
end 
 
q_u=q_u/sum_q; % 归一化 
 
% 上面这一段可以用一个语句来代替 
% q_u=reshape(histo,1,16*16*16); % 将16*16*16矩阵转换成一维矩阵 
% q_u=q_u/sum(q_u); 你可以试试 
 
%------------------------------------------------------------