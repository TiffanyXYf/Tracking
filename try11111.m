x = 0:0.0001:1;
for i = 1:length(x)
    y(i) = sqrt(2)+sin(2*pi*10*x(i))+cos(2*pi*10*x(i));
end
A = max(y);
B = min(y);