function X = my_create_particles( num_particles,centre,Hx,Hy)

X1 = randi([centre(2)-Hx,centre(2)+Hx], 1, num_particles); %width,代表横坐标
% 产生一个 1 x Npop_particles 的行向量，各元素值为 1：scenes_size(2)之间的产生的均匀分布的随机整数 
X2 = randi([centre(1)-Hy,centre(1)+Hy], 1, num_particles);%height纵坐标
% 产生一个 1 x Npop_particles 的行向量，各元素值为 1：scenes_size(2)之间的产生的均匀分布的随机整数 
X3 = zeros(1,num_particles);
X4 = zeros(1,num_particles);
X = [X1; X2; X3;X4];
