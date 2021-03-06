% 自主选定模板
clc
clear 
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%用粒子滤波器完成视觉目标跟踪
%Cuifang
%2019 2 28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 初始化
N = 500;                                    %粒子数
v_count = 193;%HSV颜色分量变成一维向量的大小
new_sita = 0.2;

%（new_sita）^2表示颜色信息的高斯分布方差。
vx=[0,0,0];
vy=[0,0,0];
% 得出目标的移动速度，如何应对目标方向发生突变的情况？
% 速度向上向左得到的平均速度
runtime=0;%求取目标速度的时候用
%产生随机粒子的方差
sigma_x=3.5;
sigma_y=3.5;



% noise = 25;
% noise2 = 5;
% sigma_n = 1;
% iamges = VideoReader('Person.WMV');
iamges = VideoReader('SampleVideo.WMV');
num_frames =  get(iamges, 'NumberOfFrames');
image_size = [iamges.Height iamges.Width];  %画布大小
video = read(iamges);%读入视频
for t = 1:num_frames    
    mov(t).cdata = video(:,:,:,t);
    %mov(t).cdata =rgb2hsv(mov(t).cdata) ;% 转换为hsv空间  
    mov(t).colormap = [];
end

Frame = {mov.cdata}; %将所有的帧数据都保存在Frame中
prompt= 'input frame_number ';
x = input(prompt);
imshow(Frame{x});
rect = getrect();
cmin = rect(1); 
cmax = rect(1) + rect(3);
rmin = rect(2);
rmax = rect(2) + rect(4);
Frame = Frame(x:end);
num_frames = length(Frame);

%% 初始化：标记目标在图像中的位置，计算其颜色直方图，初始化粒子集
centre_x =round((cmax+cmin)/2);
centre_y =round((rmin+rmax)/2) ;                   %在矩阵中x表示列，y表示行
%得到描述目标轮廓的椭圆的长短半轴的平方
% Hx = ((cmax-cmin)/3)^2;                    %round()四舍五入取整
% Hy = ((rmax-rmin)/3)^2;
Hx = ((cmax-cmin)/3)^2;                    %round()四舍五入取整
Hy = ((rmax-rmin)/3)^2;
bound_x = image_size(2);
bound_y = image_size(1);
[H, S, V]=rgb_to_rank(Frame{1});
%c初始化粒子，估计，和第一帧图像的颜色直方图
[Sample_Set,Sample_probability,Estimate,target_histgram]=myinitialize(centre_x,centre_y,...
Hx,Hy,H,S,V,N,bound_x,bound_y,v_count,new_sita);
%输出：粒子，粒子权重，估计坐标（也就是粒子的平均坐标），目标的直方图
pre_probability(1)=Estimate(1).probability;

%% 粒子传播，系统观测，目标状态估计，重采样，目标模板更新
target_centre = cell(1,num_frames);
p_u = cell(1,N);
W = zeros(1,N);
D = zeros(1,N);

set(gcf,'DoubleBuffer','on');                 % 设置双缓冲,防止屏幕闪烁
figure(1);hold on;


for t = 2:num_frames
    image = Frame{t};
    [H,S,V] = rgb_to_rank(image);%计算当前帧的HSV空间
     %产生随机粒子，根据随机情况更新粒子的位置，粒子边界的判定
    [Sample_Set,after_prop]=myreproduce(Sample_Set,vx,vy,bound_x,bound_y,...
        image,N,sigma_x,sigma_y,runtime);
    %输出：位置随系统随机更新的粒子，以及包含各个粒子位置的图像。
    
    %得出被跟踪目标的在当前帧的预测位置。计算每一个粒子的颜色直方图
    [Sample_probability,Estimate,vx,vy,TargetPic,Sample_histgram] = myevaluate(Sample_Set,...
        Estimate,target_histgram,new_sita,t,after_prop,H,S,V,N,bound_x,bound_y,v_count,vx,vy,Hx,Hy,Sample_probability);
    %输出：粒子的权重（通过计算粒子与目标的距离更新后的），目标的估计值（其中包含估计坐标，估计值所在位置对应的直方图，
    %      以及当前位置与目标之间的距离计算出来的权重），目标的运动速度估计（用于当做系统的状态的参数）
    %      包含目标轮廓的图，各个粒子的直方图。
    
    %模板更新时和重采用判断时，都要用到归一化的权值Sample_probability
     if(t<=10) %前10帧属于特殊情况，需要额外进行处理
        sum_probability=0;
        for p=1:t-1
            sum_probability=sum_probability+pre_probability(p);
        end 
        mean_probability=sum_probability/(t-1);
     else %直接求取均值
        mean_probability=mean(pre_probability);
     end
    mean_probability;
    Estimate(t).probability;
    if(Estimate(t).probability>mean_probability)
    [target_histgram,pre_probability]=update_target(target_histgram,Sample_histgram,...
        Sample_probability,pre_probability,Estimate,N,v_count,t,resample_judge);
   %不进行模板更新，但是要对pre_probability进行更新操作
    else if(t>10)
        for k=1:9
            pre_probability(k)=pre_probability(k+1);
        end
        pre_probability(10)=Estimate(t).probability;
        else 
            pre_probability(t)=Estimate(t).probability;
        end
    end
     resample_judge=0;
      %判断是否需要重采样
    back_sum_weight=0;
    for judge=1:N
        back_sum_weight=back_sum_weight+(Sample_probability(judge))^2;
    end
    sum_weight=1/back_sum_weight;
    if(sum_weight<N/2)
        %重采样过程
        usetimes=reselect(Sample_Set,Sample_probability,N);
        [Sample_Set,Sample_probability] = assemble(Sample_Set,usetimes,Sample_probability,N);%进行线性组合
        resample_judge=1;
    end
    
     %得到目标运动的轨迹
    if(t==2)
        routine.x=round(Estimate(t).x);
        routine.y=round(Estimate(t).y);
    else
        routine(t-1).x=round(Estimate(t).x);
        routine(t-1).y=round(Estimate(t).y);
    end
    i=1;
    j=1;
    while(j<=t-1)
        for new_x=routine(j).x-i:routine(j).x+i%出现0值和图像无关，因为有时候估计值已经到了图像的最边沿的部分
           
            for new_y=routine(j).y:routine(j).y+i
                if new_x ~= 0 && new_y ~=0
                    TargetPic(new_y,new_x,1)=0;
                    TargetPic(new_y,new_x,2)=0;
                    TargetPic(new_y,new_x,3)=255;
                end
           end
        end   
        j=j+1;
    end 
%画出每一帧图像中跟踪目标的预测中心点
i=1;
for new_x=round(Estimate(t).x)-i:round(Estimate(t).x+i)
       for new_y=round(Estimate(t).y)-i:round(Estimate(t).y+i)
          if new_x ~= 0 && new_y ~=0
              TargetPic(new_y,new_x,1)=255;
              TargetPic(new_y,new_x,2)=255;
              TargetPic(new_y,new_x,3)=255;
          end
       end
end

     imshow(TargetPic);
     F = getframe;
     title(['the ',num2str(t),'th frame']);

end



















