% clc
% clear 
% close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 结合粒子滤波思想完成快速模板匹配
% Cuifang
% 2019 4 8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 初始化：参数，跟踪视频读入
N = 600;                                    %粒子数
v_count = 193;%HSV颜色分量变成一维向量的大小
new_sita = 0.2;

%（new_sita）^2表示颜色信息的高斯分布方差。
vx=[0,0,0];
vy=[0,0,0];
%得出目标的移动速度
runtime=0;%求取目标速度的时候用
%产生随机粒子的方差
sigma_x=3.5;
sigma_y=3.5;

iamges = VideoReader('SampleVideo.WMV');
% iamges = VideoReader('industry.MP4');
num_frames =  get(iamges, 'NumberOfFrames');
image_size = [iamges.Height iamges.Width];  %画布大小
video = read(iamges);%读入视频
for t = 1:num_frames    
    mov(t).cdata = video(:,:,:,t);
    %mov(t).cdata =rgb2hsv(mov(t).cdata) ;% 转换为hsv空间  
    mov(t).colormap = [];
end

Frame = {mov.cdata}; %将所有的帧数据都保存在Frame中
%% 初始化：得到模板的特征（颜色直方图）
% template = imread('template_foreign.jpg');
template = imread('template_yujinxiang.jpg');
% template = imread('badtemplate.jpg');
% template = imread('template_in.jpg');
[bound_y,bound_x] = size(template(:,:,1));
[H, S, V]=rgb_to_rank(template);
Hx = (bound_x/2)^2;
Hy = (bound_y/2)^2;
x = round(bound_x/2);
y = round(bound_y/2); % 模板图片的中心坐标
target_histgram = myin_histgram(x,y,Hx,Hy,H,S,V,bound_x,bound_y,v_count);
%% 粒子的初始化：粒子的位置、权重、第一次估计

% 下面是用于视频的情况下：
% bound_x = image_size(2);
% bound_y = image_size(1);
% [H,S,V] = rgb_to_rank(Frame{1});
% image = Frame{1}; % 选择特定的图片 


% 下面用于图片：
% image = imread('ShetlerFamily06.jpg');
image = imread('yujinxiang.jpg');
bound_x = size(image(:,:,1),2);
bound_y = size(image(:,:,1),1);
[H,S,V] = rgb_to_rank(image);

[Sample_Set,Sample_probability,Estimate] = myin_particles(Hx,Hy,H,S,V,...
    bound_x,bound_y,N,v_count,new_sita,target_histgram);

% 初始化粒子，估计，和第一帧图像的颜色直方图
% pre_probability 是否需要？
% pre_probability(1)=Estimate(1).probability; % 参数pre_probability 是用于判断模板是否需要更新的参数。
% 这个参数用于计算一个meanprobability，然后通过与当前估计的estimate-probability进行比较，
% 如果当前的估计距离更近，说明模板可以更新了。（说明已经很接近了，如果接近到一定程度了，就可以代替原来的
% 模板了，因为原来的模板可能与当前的背景不同，背景会对颜色直方图产生影响）

%% 对于图像的：粒子传播，系统观测，目标状态估计，重采样，目标模板更新

set(gcf,'DoubleBuffer','on');                 % 设置双缓冲,防止屏幕闪烁
% figure(1);hold on;
% imshow(Frame{1});
% resample_judge=0; % 判断是否重采样的标志
% 确定每次计算完成之后都进行重采样的操作。
% 对于每一张图片都进行确定次数的迭代，使其收敛到图片中与模板最接近的位置。
% 有一个未考虑的问题：如何在第一开始就确定图片中有没有模板对应的相似的东西？？？？？
Iteration = 20;

% image = Frame{1}; % 选择特定的图片 
% image = imread('ShetlerFamily06.jpg');


[H,S,V] = rgb_to_rank(image); %计算当前帧的HSV 
for i = 1:Iteration % 粒子滤波迭代求收敛位置
    % 计算粒子位置更新的情况()空间
    [Sample_Set,after_prop]=im_reproduce(Sample_Set,...
    bound_x,bound_y,image,N,sigma_x,sigma_y);   
    % 接下来需要完成的功能：计算对应的观测值，对粒子重新分配权值，权值归一化,重采样，重新分配权值。
    [Sample_Set,Sample_probability, Estimate,TargetPic,sample_histgram] = ...
             im_evaluate(Sample_Set,Estimate,target_histgram,new_sita,i,...
             after_prop,H,S,V,N,bound_x,bound_y,v_count,Hx,Hy,Sample_probability);
    
end


%% show result
imshow(TargetPic)
title([num2str(N),' sampled points ',num2str(Iteration),' iteration'])





















