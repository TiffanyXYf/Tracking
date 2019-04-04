function [sample_set,sample_probability,estimate] = myin_particles(Hx,Hy,H,S,V,...
    bound_x,bound_y,N,v_count,new_sita,target_histgram)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function: ��ʼ�����ӣ����ӵ�λ�á�Ȩ���Լ���Ŀ��ĵ�һ��������ƣ������ӽ�����Ȩ�صļ�����ز�����
% input:    ģ��Ĵ�С��֡��HSV��֡�Ļ����ߴ磨��Ƶ֡�ĳߴ磩����������ֱ��ͼ������������Ȩ�ص��õĸ�˹�ֲ��ķ���
% output:   �����ڻ����е����ꡢȨ�ء���Ŀ��Ĺ��ƣ������а������ǣ�λ�á�ֱ��ͼ�����ʣ�
%           ���Ƶĸ��ʣ���ʾ��ǰ��ģ��Ĺ��ƺ���ʵģ��ľ�����������Ȩ��
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
 [sample_set,sample_probability] = assemble(sample_set,usetimes,sample_probability,N);%�����������
end