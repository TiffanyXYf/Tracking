function [new_sample_probability, estimate,vx,vy,targetpic,sample_histgram] = ...
    myevaluate(sampleset,estimate,target_histgram,new_sita,loop,after_prop,H,S,V,N,bound_x,bound_y,v_count,vx,vy,Hx,Hy,sample_probability)
% This function is used to calculate the trajectory of the target, and get
% the location of the particles
%loop is the order of eritations,new_sita
%after_prop is the image, and targetpic is the image with the trajectory of
%the target and particles
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

%calculate the velocity and get the shape of the oval
%This part is a little strange, why should I do this: The velocity is used
%for the next step__update the particles.
% calculate the velocity
if loop ==1
    a = round(estimate(loop).x);
    b = 0;
    vx(1) = vx(2);
    vx(2) = vx(3);
    vx(3) = a-b;
    c=round(estimate(loop).y);
    d=0;
    vy(1)=vy(2);
    vy(2)=vy(3);
    vy(3)=c-d;
else
    
    a = round(estimate(loop).x);
    b = round(estimate(loop-1).x);
    vx(1) = vx(2);
    vx(2) = vx(3);
    vx(3) = a-b;
    c=round(estimate(loop).y);
    d=round(estimate(loop-1).y);
    vy(1)=vy(2);
    vy(2)=vy(3);
    vy(3)=c-d;
end
% get the trajectory of the oval
%用椭圆表示被跟踪目标的轮廓
a1=(double(Hx))^0.5;
b1=(double(Hy))^0.5;
        i=0;
        for angle=pi/10000:pi/1000:2*pi 
            i=i+1;
            x(i)=round(cos(angle)*a1+ estimate(loop).x); %椭圆的参数方程    
            y(i)=round(sin(angle)*b1+ estimate(loop).y);   
        end
        for index_b=1:i
            if(x(index_b)<bound_x)   %不超出范围
                if(y(index_b)<bound_y)
                    if(x(index_b)>0)
                        if(y(index_b)>0)
                            targetpic(y(index_b),x(index_b),1)=0;
                            targetpic(y(index_b),x(index_b),2)=255;
                            targetpic(y(index_b),x(index_b),3)=0;%循环画圆
                        end
                    end
                end
            end
        end

end