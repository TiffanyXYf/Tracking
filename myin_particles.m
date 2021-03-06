function [sample_set,sample_probability,estimate] = myin_particles(Hx,Hy,H,S,V,...
    bound_x,bound_y,N,v_count,new_sita,target_histgram)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function: 初始化粒子，粒子的位置、权重以及对目标的第一次随机估计（对粒子进行了权重的计算和重采样）
% input:    模板的大小、帧的HSV、帧的画布尺寸（视频帧的尺寸）、粒子数、直方图的条数、计算权重的用的高斯分布的方差
% output:   粒子在画布中的坐标、权重、对目标的估计（估计中包含的是：位置、直方图、概率）
%           估计的概率：表示当前对模板的估计和真实模板的距离计算出来的权重
% author:   Cuifang
% date:     2019 April 4th
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sample_set = struct('x',[],'y',[]);
sample_set  = repmat(sample_set ,[1,N]);
sample_probability = zeros(1,N);
setx = zeros(1,N);
sety = zeros(1,N);
% sample_probability2 = zeros(1,N);

for i = 1:N
    sample_set(i).x = floor(1+(bound_x-1)*rand());
    setx(i) = sample_set(i).x;
    sample_set(i).y = floor(1+(bound_y-1)*rand());
    sety(i) =sample_set(i).y;
    current_hist = myhistgram(sample_set(i).x,sample_set(i).y,Hx,Hy,H,S,V,bound_x,bound_y,v_count);
    sample_probability(i) = myweight(current_hist,target_histgram,new_sita,v_count);
end

sample_probability = sample_probability/sum(sample_probability);

estimate(1).x = round(sample_probability*setx');
estimate(1).y = round(sample_probability*sety'); 
estimate(1).histgram = myhistgram(estimate(1).x,estimate(1).y,Hx,Hy,H,S,V,bound_x,bound_y,v_count);
%myhistgram(x,y,Hx,Hy,H,S,V,bound_x,bound_y,v_count)
estimate(1).probability = myweight(estimate(1).histgram,target_histgram,new_sita,v_count);
% resample
 usetimes=reselect(sample_set,sample_probability,N);
 [sample_set,sample_probability] = assemble(sample_set,usetimes,sample_probability,N);%进行线性组合
end