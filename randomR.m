function out1 = randomR(inIndex,q)%X = randomR(X,L_log)

% function X = resample_particles(X, L_log)
% 
% % Calculating Cumulative Distribution
% 
% L = exp(L_log - max(L_log));
% Q = L / sum(L, 2);  % a = sum(L,2)  a��Ԫ��Ϊ���������ۼ�ֵ
% R = cumsum(Q, 2);
% 
% % Generating Random Numbers
% 
% N = size(X, 2);
% T = rand(1, N);
% 
% % Resampling
% 
% [~, I] = histc(T, R);%histc��ͳ����RΪ�����T��Ԫ�ص�ͳ�Ƹ���I�м�¼T�е�Ԫ����R�ĵڼ��������м�
% X = X(:, I + 1);%������ֵ����Ԫ���ڵڼ������䣬����+1�����ҽ�X����ƽ����Ϊʲô��

if nargin<2
    error('no enough input argument');
end
out1 = zeros(size(inIndex));
[num,col] = size(q);
%�������������������
u = rand(num,1);
u = sort(u);
cdf = cumsum(q);% calculate the sum of weight of one kind of particle
% ���ļ���
i = 1;
for j = 1:num
    while(i<=num)&& (u(i)<=cdf(j))
        out1(i) = j;
        i = i+1;
    end
end

end