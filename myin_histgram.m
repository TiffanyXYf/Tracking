function pqu =myin_histgram(x,y,Hx,Hy,H,S,V,bound_x,bound_y,v_count)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function：计算图片模板的直方图
% input：   centre of the template， 构造椭圆的参数Hx和Hy
%           HSV of the template， size of the template，直方图的条柱数
% author：  Cuifang
% date：    2019 April 3th
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% x = round(Hx);
% y = round(Hy);
a = (Hx^2+Hy^2)^0.5;
matrix = 1:v_count;   %record the histgram line
e = round((Hx)^0.5);
f = round((Hy)^0.5);
pqu = zeros(1,v_count);
q = 0;
for i = (x-e):(x+e)
    for j = (y-f):(y+f) 
        if (x-i)^2/Hx+(y-j)^2/Hy <=1 && i>= 1&&i<= bound_x&& j>=1&& j<=bound_y
            hxi = matrix(H(j,i)*4+S(j,i)*3+V(j,i)+1);
            distance = (double((x-i).^2)+double((y - j).^2))^0.5/a;       
            pqu(hxi) = pqu(hxi)+0.75*(1-distance^2);
            q = q+0.75*(1-distance^2);
        end
    end
end
pqu = pqu/q;

end