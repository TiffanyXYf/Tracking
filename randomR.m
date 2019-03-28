function out1 = randomR(inIndex,q)%X = randomR(X,L_log)

% function X = resample_particles(X, L_log)
% 
% % Calculating Cumulative Distribution
% 
% L = exp(L_log - max(L_log));
% Q = L / sum(L, 2);  % a = sum(L,2)  a中元素为各行向量累加值
% R = cumsum(Q, 2);
% 
% % Generating Random Numbers
% 
% N = size(X, 2);
% T = rand(1, N);
% 
% % Resampling
% 
% [~, I] = histc(T, R);%histc会统计以R为区间的T中元素的统计个数I中记录T中的元素在R的第几个区间中间
% X = X(:, I + 1);%本程序值保留元素在第几个区间，区间+1，并且将X进行平移是为什么？

if nargin<2
    error('no enough input argument');
end
out1 = zeros(size(inIndex));
[num,col] = size(q);
%产生随机数组升序排序
u = rand(num,1);
u = sort(u);
cdf = cumsum(q);% calculate the sum of weight of one kind of particle
% 核心计算
i = 1;
for j = 1:num
    while(i<=num)&& (u(i)<=cdf(j))
        out1(i) = j;
        i = i+1;
    end
end

end