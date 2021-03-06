function [sampleset,after_prop]=myreproduce(sampleset,...
    vx,vy,bound_x,bound_y,I,N,sigma_x,sigma_y,runtime)
%This function is used to reproduce particles for our system
%the particles depend on vx and xy the velocity of the first three frame of
%the video
after_prop=I;

if runtime ==1
    pvx=vx(3);
    pvy=vy(3);
elseif runtime ==2
    pvx = (vx(2)+vx(3))/2;
    pvy = (vy(2)+vy(3))/2;
else
     pvx = mean(vx);
     pvy = mean(vy);
end
% pvx = 0;
% pvy = 0;
% Here a question: why 10*N?
randx = random('Normal',pvx,sigma_x,1,10*N);
randy = random('Normal',pvy,sigma_y,1,10*N);


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