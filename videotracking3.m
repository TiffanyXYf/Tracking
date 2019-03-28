% ����ѡ��ģ��
clc
clear 
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������˲�������Ӿ�Ŀ�����
%Cuifang
%2019 2 28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��ʼ��
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



% noise = 25;
% noise2 = 5;
% sigma_n = 1;
% iamges = VideoReader('Person.WMV');
iamges = VideoReader('SampleVideo.WMV');
num_frames =  get(iamges, 'NumberOfFrames');
image_size = [iamges.Height iamges.Width];  %������С
video = read(iamges);%������Ƶ
for t = 1:num_frames    
    mov(t).cdata = video(:,:,:,t);
    %mov(t).cdata =rgb2hsv(mov(t).cdata) ;% ת��Ϊhsv�ռ�  
    mov(t).colormap = [];
end

Frame = {mov.cdata}; %�����е�֡���ݶ�������Frame��
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

%% ��ʼ�������Ŀ����ͼ���е�λ�ã���������ɫֱ��ͼ����ʼ�����Ӽ�
centre_x =round((cmax+cmin)/2);
centre_y =round((rmin+rmax)/2) ;                   %�ھ�����x��ʾ�У�y��ʾ��
%�õ�����Ŀ����������Բ�ĳ��̰����ƽ��
Hx = ((cmax-cmin)/3)^2;                    %round()��������ȡ��
Hy = ((rmax-rmin)/3)^2;
bound_x = image_size(2);
bound_y = image_size(1);
[H, S, V]=rgb_to_rank(Frame{1});
%c��ʼ�����ӣ����ƣ��͵�һ֡ͼ�����ɫֱ��ͼ
[Sample_Set,Sample_probability,Estimate,target_histgram]=myinitialize(centre_x,centre_y,...
Hx,Hy,H,S,V,N,bound_x,bound_y,v_count,new_sita);
%��������ӣ�����Ȩ�أ��������꣨Ҳ�������ӵ�ƽ�����꣩��Ŀ���ֱ��ͼ
pre_probability(1)=Estimate(1).probability;

%% ���Ӵ�����ϵͳ�۲⣬Ŀ��״̬���ƣ��ز�����Ŀ��ģ�����
target_centre = cell(1,num_frames);
p_u = cell(1,N);
W = zeros(1,N);
D = zeros(1,N);

set(gcf,'DoubleBuffer','on');                 % ����˫����,��ֹ��Ļ��˸
figure(1);hold on;


for t = 2:num_frames
    image = Frame{t};
    [H,S,V] = rgb_to_rank(image);%���㵱ǰ֡��HSV�ռ�
     %����������ӣ������������������ӵ�λ�ã����ӱ߽���ж�
    [Sample_Set,after_prop]=myreproduce(Sample_Set,vx,vy,bound_x,bound_y,...
        image,N,sigma_x,sigma_y,runtime);
    %�����λ����ϵͳ������µ����ӣ��Լ�������������λ�õ�ͼ��
    
    %�ó�������Ŀ����ڵ�ǰ֡��Ԥ��λ�á�����ÿһ�����ӵ���ɫֱ��ͼ
    [Sample_probability,Estimate,vx,vy,TargetPic,Sample_histgram] = myevaluate(Sample_Set,...
        Estimate,target_histgram,new_sita,t,after_prop,H,S,V,N,bound_x,bound_y,v_count,vx,vy,Hx,Hy,Sample_probability);
    %��������ӵ�Ȩ�أ�ͨ������������Ŀ��ľ�����º�ģ���Ŀ��Ĺ���ֵ�����а����������꣬����ֵ����λ�ö�Ӧ��ֱ��ͼ��
    %      �Լ���ǰλ����Ŀ��֮��ľ�����������Ȩ�أ���Ŀ����˶��ٶȹ��ƣ����ڵ���ϵͳ��״̬�Ĳ�����
    %      ����Ŀ��������ͼ���������ӵ�ֱ��ͼ��
    
    %ģ�����ʱ���ز����ж�ʱ����Ҫ�õ���һ����ȨֵSample_probability
     if(t<=10) %ǰ10֡���������������Ҫ������д���
        sum_probability=0;
        for p=1:t-1
            sum_probability=sum_probability+pre_probability(p);
        end 
        mean_probability=sum_probability/(t-1);
     else %ֱ����ȡ��ֵ
        mean_probability=mean(pre_probability);
     end
    mean_probability;
    Estimate(t).probability;
    if(Estimate(t).probability>mean_probability)
    [target_histgram,pre_probability]=update_target(target_histgram,Sample_histgram,...
        Sample_probability,pre_probability,Estimate,N,v_count,t,resample_judge);
   %������ģ����£�����Ҫ��pre_probability���и��²���
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
      %�ж��Ƿ���Ҫ�ز���
    back_sum_weight=0;
    for judge=1:N
        back_sum_weight=back_sum_weight+(Sample_probability(judge))^2;
    end
    sum_weight=1/back_sum_weight;
    if(sum_weight<N/2)
        %�ز�������
        usetimes=reselect(Sample_Set,Sample_probability,N);
        [Sample_Set,Sample_probability] = assemble(Sample_Set,usetimes,Sample_probability,N);%�����������
        resample_judge=1;
    end
    
     %�õ�Ŀ���˶��Ĺ켣
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
        for new_x=routine(j).x-i:routine(j).x+i%����0ֵ��ͼ���޹أ���Ϊ��ʱ�����ֵ�Ѿ�����ͼ�������صĲ���
           
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
%����ÿһ֡ͼ���и���Ŀ���Ԥ�����ĵ�
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


















