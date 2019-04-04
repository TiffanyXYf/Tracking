function [sampleset,after_prop]=im_reproduce(sampleset,...
    bound_x,bound_y,I,N,sigma_x,sigma_y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function:  ���ӵ�λ�ý���һ�θ��£����������������
%            �����ͼ�񣬲���Ҫ�������λ��ƽ�ƣ���
% input:     ����λ�ã������߽磬ͼ��x,y����ĸ��µķ������ԵĴ�С����"���е����Ĵ���"
% output:    ���ӵ���λ�á�����������ӵ�ͼ��
% author:    Cuifang
% date:      2019 April 4th
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

after_prop=I;% I �������image

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