function [New_Sample_probability,Estimate,vx,vy,TargetPic,Sample_histgram]=evaluate(Sample_Set,Estimate,target_histgram,new_sita,loop,after_prop,H,S,V,N,image_boundary_x,image_boundary_y,v_count,vx,vy,Hx,Hy,Sample_probability)
TargetPic=after_prop;
Total_probability=0;
Sample_histgram=zeros(N,v_count);

for i=1:N
    Sample_histgram(i,:)=histgram((Sample_Set(i).x),(Sample_Set(i).y),Hx,Hy,H,S,V,image_boundary_x,image_boundary_y,v_count); 
    %��ÿһ������ȷ���ĺ�ѡģ����HSV�ռ����ɫֱ��ͼ
    New_Sample_probability(i)=Sample_probability(i)*weight(target_histgram,Sample_histgram(i,:),new_sita,v_count);
% New_Sample_probability(i)=weight(target_histgram,Sample_histgram(i,:),new_sita,v_count);
    %Ŀ����Ϊ�˹�һ��
    Total_probability=Total_probability+New_Sample_probability(i);
end


%Ȩֵ��һ��
New_Sample_probability=New_Sample_probability./Total_probability;

%�õ�������Ŀ���ڵ�ǰ֡��Ԥ��λ��
Estimate(loop).x=0;
Estimate(loop).y=0;
for i=1:1:N
    Estimate(loop).x=Estimate(loop).x+double(Sample_Set(i).x)*New_Sample_probability(i);
    Estimate(loop).y=Estimate(loop).y+double(Sample_Set(i).y)*New_Sample_probability(i);
end

%��Ԥ��Ŀ��ģ����Ŀ��ģ����бȽϣ��Եõ�ʵ�ʵĸ���Ч�����ڴ˻����Ͼ����Ƿ���Ҫ���в�����
Estimate(loop).histgram=histgram(round(Estimate(loop).x),round(Estimate(loop).y),Hx,Hy,H,S,V,image_boundary_x,image_boundary_x,v_count);
Estimate(loop).probability=weight(target_histgram,Estimate(loop).histgram,new_sita,v_count);  
                                                                              
                                                

%����Ŀ���ƶ����ٶ�
a=round(Estimate(loop).x);
b=round(Estimate(loop-1).x);
vx(1)=vx(2);
vx(2)=vx(3);
vx(3)=a-b;
c=round(Estimate(loop).y);
d=round(Estimate(loop-1).y);
vy(1)=vy(2);
vy(2)=vy(3);
vy(3)=c-d;

%����Բ��ʾ������Ŀ�������
a1=(double(Hx))^0.5;
b1=(double(Hy))^0.5;
        i=0;
        for angle=pi/10000:pi/1000:2*pi 
            i=i+1;
            x(i)=round(cos(angle)*a1+ Estimate(loop).x); %��Բ�Ĳ�������    
            y(i)=round(sin(angle)*b1+ Estimate(loop).y);   
        end
        for index_b=1:i
            if(x(index_b)<image_boundary_x)   %��������Χ
                if(y(index_b)<image_boundary_y)
                    if(x(index_b)>0)
                        if(y(index_b)>0)
                            TargetPic(y(index_b),x(index_b),1)=0;
                            TargetPic(y(index_b),x(index_b),2)=255;
                            TargetPic(y(index_b),x(index_b),3)=0;%ѭ����Բ
                        end
                    end
                end
            end
        end