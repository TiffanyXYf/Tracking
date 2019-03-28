function probability= myweight(pre_histgram,target_histgram,new_sita,v_count)
a = 0;
for i = 1:v_count
    a = a+(pre_histgram(i)*target_histgram(i))^0.5;
end

r = (1-a)^0.5;
probability = (1/(sqrt(2*pi)*new_sita))*exp((-r^2)/(2*new_sita^2));

end