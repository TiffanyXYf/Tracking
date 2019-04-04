function [sampleset,sample_probability, estimate,targetpic,sample_histgram] = ...
             im_evaluate(sampleset,estimate,target_histgram,new_sita,loop,...
             after_prop,H,S,V,N,bound_x,bound_y,v_count,Hx,Hy,sample_probability)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function:  计算每个粒子对应的观测值，对粒子重新分配权值，权值归一化,重采样，重新分配权值            
% input:     粒子位置，系统估计值、目标的直方图、计算权值用的方差、循环的次数、包含粒子位置的图像、HSV、
%            画布边界，直方图条数、模板框的大小、粒子的权值。（粒子权值如果每次都进行重采样的话，粒子权值就是1/N或许可以不输入了）
% output:    （重采样和归一化之后的粒子的位置、粒子的新权重）、系统估计值、当前图片样式、每个粒子对应的直方图
% author:    Cuifang
% date:      2019 April 4th
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 接下来需要完成的功能：计算对应的观测值，对粒子重新分配权值，权值归一化,重采样，重新分配权值。

targetpic = after_prop;
sample_histgram = zeros(N,v_count);% store the histgram data
total_pro = 0;
%calculate the histgram of every particle and get the weight of them 
for i = 1:N
    x(i) = sampleset(i).x;%location of particle
    y(i) = sampleset(i).y;
    sample_histgram(i,:) = myhistgram(x(i),y(i),Hx,Hy,H,S,V,bound_x,bound_y,v_count);
    new_sample_probability(i) = sample_probability(i)*myweight(sample_histgram(i,:),target_histgram,new_sita,v_count);
%     new_sample_probability(i) = myweight(sample_histgram(i,:),target_histgram,new_sita,v_count);
    total_pro = total_pro+new_sample_probability(i);
end
new_sample_probability = new_sample_probability/total_pro;
%normalized the sample_probability and get the estimated location of the
%target which is the mean of the location of the particles

estimate(loop).x = new_sample_probability*x';
estimate(loop).y = new_sample_probability*y';

%calculate the histgram of the estimated location
estimate(loop).histgram = myhistgram(round(estimate(loop).x),round(estimate(loop).y),Hx,Hy,H,S,V,bound_x,bound_y,v_count);
estimate(loop).probability = myweight(estimate(loop).histgram ,target_histgram,new_sita,v_count);

% 估计完之后进行重采样权重归一化

usetimes=reselect(sampleset,new_sample_probability,N);
[sampleset,sample_probability] = assemble(sampleset,usetimes,new_sample_probability,N); %进行线性组合


%% 用椭圆表示被跟踪目标的轮廓
a1=(double(Hx))^0.5;
b1=(double(Hy))^0.5;
        i=0;
        for angle=pi/10000:pi/1000:2*pi 
            i=i+1;
            x(i)=round(cos(angle)*a1+ estimate(loop).x); %椭圆的参数方程    
            y(i)=round(sin(angle)*b1+ estimate(loop).y);   
        end
        for index_b=1:i
            if(x(index_b)<bound_x)   %不超出范围
                if(y(index_b)<bound_y)
                    if(x(index_b)>0)
                        if(y(index_b)>0)
                            targetpic(y(index_b),x(index_b),1)=0;
                            targetpic(y(index_b),x(index_b),2)=255;
                            targetpic(y(index_b),x(index_b),3)=0;%循环画圆
                        end
                    end
                end
            end
        end

end