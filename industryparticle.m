clc
clear 
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������˲�������Ӿ�Ŀ�����
%Cuifang
%2019 2 28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��ʼ����������������Ƶ����
N = 500;                                    %������
v_count = 193;%HSV��ɫ�������һά�����Ĵ�С
new_sita = 0.2;

%��new_sita��^2��ʾ��ɫ��Ϣ�ĸ�˹�ֲ����
vx=[0,0,0];
vy=[0,0,0];
%�ó�Ŀ����ƶ��ٶ�
runtime=0;%��ȡĿ���ٶȵ�ʱ����
%����������ӵķ���
sigma_x=3.5;
sigma_y=3.5;

% iamges = VideoReader('SampleVideo.WMV');
iamges = VideoReader('industry.MP4');
num_frames =  get(iamges, 'NumberOfFrames');
image_size = [iamges.Height iamges.Width];  %������С
video = read(iamges);%������Ƶ
for t = 1:num_frames    
    mov(t).cdata = video(:,:,:,t);
    %mov(t).cdata =rgb2hsv(mov(t).cdata) ;% ת��Ϊhsv�ռ�  
    mov(t).colormap = [];
end

Frame = {mov.cdata}; %�����е�֡���ݶ�������Frame��
%% ��ʼ�����õ�ģ�����������ɫֱ��ͼ��
% template = imread('template2.jpg');
% template = imread('badtemplate.jpg');
template = imread('template_in.jpg');
[bound_y,bound_x] = size(template(:,:,1));
[H, S, V]=rgb_to_rank(template);
Hx = (bound_x/2)^2;
Hy = (bound_y/2)^2;
x = round(bound_x/2);
y = round(bound_y/2); % ģ��ͼƬ����������
target_histgram = myin_histgram(x,y,Hx,Hy,H,S,V,bound_x,bound_y,v_count);
%% ���ӵĳ�ʼ�������ӵ�λ�á�Ȩ�ء���һ�ι���
bound_x = image_size(2);
bound_y = image_size(1);
[H,S,V] = rgb_to_rank(Frame{1});
[Sample_Set,Sample_probability,Estimate] = myin_particles(Hx,Hy,H,S,V,...
    bound_x,bound_y,N,v_count,new_sita,target_histgram);

% ��ʼ�����ӣ����ƣ��͵�һ֡ͼ�����ɫֱ��ͼ
% pre_probability �Ƿ���Ҫ��
% pre_probability(1)=Estimate(1).probability; % ����pre_probability �������ж�ģ���Ƿ���Ҫ���µĲ�����
% ����������ڼ���һ��meanprobability��Ȼ��ͨ���뵱ǰ���Ƶ�estimate-probability���бȽϣ�
% �����ǰ�Ĺ��ƾ��������˵��ģ����Ը����ˡ���˵���Ѿ��ܽӽ��ˣ�����ӽ���һ���̶��ˣ��Ϳ��Դ���ԭ����
% ģ���ˣ���Ϊԭ����ģ������뵱ǰ�ı�����ͬ�����������ɫֱ��ͼ����Ӱ�죩

%% ����ͼ��ģ����Ӵ�����ϵͳ�۲⣬Ŀ��״̬���ƣ��ز�����Ŀ��ģ�����

set(gcf,'DoubleBuffer','on');                 % ����˫����,��ֹ��Ļ��˸
figure(1);hold on;
imshow(Frame{1});
% resample_judge=0; % �ж��Ƿ��ز����ı�־
% ȷ��ÿ�μ������֮�󶼽����ز����Ĳ�����
% ����ÿһ��ͼƬ������ȷ�������ĵ�����ʹ��������ͼƬ����ģ����ӽ���λ�á�
% ��һ��δ���ǵ����⣺����ڵ�һ��ʼ��ȷ��ͼƬ����û��ģ���Ӧ�����ƵĶ�������������
Iteration = 3;
image = Frame{50}; % ѡ���ض���ͼƬ 
[H,S,V] = rgb_to_rank(image); % ���㵱ǰ֡��HSV 
for i = 1:Iteration % �����˲�����������λ��
    % ��������λ�ø��µ����()�ռ�
    [Sample_Set,after_prop]=im_reproduce(Sample_Set,...
    bound_x,bound_y,image,N,sigma_x,sigma_y);   
    % ��������Ҫ��ɵĹ��ܣ������Ӧ�Ĺ۲�ֵ�����������·���Ȩֵ��Ȩֵ��һ��,�ز��������·���Ȩֵ��
    [Sample_Set,Sample_probability, Estimate,TargetPic,sample_histgram] = ...
             im_evaluate(Sample_Set,Estimate,target_histgram,new_sita,i,...
             after_prop,H,S,V,N,bound_x,bound_y,v_count,Hx,Hy,Sample_probability);
    
end

imshow(TargetPic)
%% show result





















