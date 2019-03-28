function [sample_set, sample_probability, estimate, target_histgram] = ...
    myinitialize(x,y,Hx,Hy,H,S,V,N,bound_x,bound_y,v_count,new_sita)
%This function is used to initialize samples and their probabilities 
%This function is also used to calculate the target_histgram because we
%have the funvtion of my histgram. And the estimate is the mean location of
%the particles

noise  = random('Normal',0,new_sita,1,N);
for i = 1:N
    sample_set(i).x = x;
    sample_set(i).y = y;
%     sample_set(i).x = floor(1+(bound_x-1)*rand());
%     sample_set(i).y = floor(1+(bound_y-1)*rand());
    sample_probability(i) = 1/N;
end
target_histgram = myhistgram(x,y,Hx,Hy,H,S,V,bound_x,bound_y,v_count);
estimate(1).x  = sample_set(1).x;
estimate(1).y  = sample_set(1).y;
estimate(1).histgram = target_histgram;
estimate(1).probability = myweight(estimate(1).histgram,target_histgram,new_sita,v_count);

end