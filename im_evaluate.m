function [sampleset,sample_probability, estimate,targetpic,sample_histgram] = ...
             im_evaluate(sampleset,estimate,target_histgram,new_sita,loop,...
             after_prop,H,S,V,N,bound_x,bound_y,v_count,Hx,Hy,sample_probability)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function:  ����ÿ�����Ӷ�Ӧ�Ĺ۲�ֵ�����������·���Ȩֵ��Ȩֵ��һ��,�ز��������·���Ȩֵ            
% input:     ����λ�ã�ϵͳ����ֵ��Ŀ���ֱ��ͼ������Ȩֵ�õķ��ѭ���Ĵ�������������λ�õ�ͼ��HSV��
%            �����߽磬ֱ��ͼ������ģ���Ĵ�С�����ӵ�Ȩֵ��������Ȩֵ���ÿ�ζ������ز����Ļ�������Ȩֵ����1/N������Բ������ˣ�
% output:    ���ز����͹�һ��֮������ӵ�λ�á����ӵ���Ȩ�أ���ϵͳ����ֵ����ǰͼƬ��ʽ��ÿ�����Ӷ�Ӧ��ֱ��ͼ
% author:    Cuifang
% date:      2019 April 4th
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ��������Ҫ��ɵĹ��ܣ������Ӧ�Ĺ۲�ֵ�����������·���Ȩֵ��Ȩֵ��һ��,�ز��������·���Ȩֵ��

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

% ������֮������ز���Ȩ�ع�һ��

usetimes=reselect(sampleset,new_sample_probability,N);
[sampleset,sample_probability] = assemble(sampleset,usetimes,new_sample_probability,N); %�����������


%% ����Բ��ʾ������Ŀ�������
a1=(double(Hx))^0.5;
b1=(double(Hy))^0.5;
        i=0;
        for angle=pi/10000:pi/1000:2*pi 
            i=i+1;
            x(i)=round(cos(angle)*a1+ estimate(loop).x); %��Բ�Ĳ�������    
            y(i)=round(sin(angle)*b1+ estimate(loop).y);   
        end
        for index_b=1:i
            if(x(index_b)<bound_x)   %��������Χ
                if(y(index_b)<bound_y)
                    if(x(index_b)>0)
                        if(y(index_b)>0)
                            targetpic(y(index_b),x(index_b),1)=0;
                            targetpic(y(index_b),x(index_b),2)=255;
                            targetpic(y(index_b),x(index_b),3)=0;%ѭ����Բ
                        end
                    end
                end
            end
        end

end