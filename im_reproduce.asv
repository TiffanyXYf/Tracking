function [sampleset,after_prop]=im_reproduce(sampleset,...
    bound_x,bound_y,I,N,sigma_x,sigma_y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function:  粒子的位置进行一次更新，并且输出到画布中
%            相对于图像，不需要做过多的位置平移（）
% input:     粒子位置，画布边界，图像，x,y坐标的更新的方差（随机性的大小）、"进行迭代的次数"
% output:    粒子的新位置、包含输出粒子的图像
% author:    Cuifang
% date:      2019 April 4th
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

after_prop=I;% I 是输入的image

% Here a question: why 10*N?
randx = random('Normal',0,sigma_x,1,10*N);
randy = random('Normal',0,sigma_y,1,10*N);


for i = 1:N
    original_x = sampleset(i).x;
    original_y = sampleset(i).y;
    noise_x = round(randx(i));
    noise_y = round(randy(i));
    sampleset(i).x  = original_x+noise_x;
    sampleset(i).y  = original_y+noise_y;
    if sampleset(i).x < 1
        sampleset(i).x = 1;
    elseif sampleset(i).x>bound_x
        sampleset(i).x = bound_x;
    end
    if sampleset(i).y <1
        sampleset(i).y = 1;
    elseif sampleset(i).y>bound_y
        sampleset(i).y = bound_y;
    end
      after_prop(sampleset(i).y,sampleset(i).x,1)=255; 
      after_prop(sampleset(i).y,sampleset(i).x,2)=0;
      after_prop(sampleset(i).y,sampleset(i).x,3)=0;
end
end