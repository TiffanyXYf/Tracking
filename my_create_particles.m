function X = my_create_particles( num_particles,centre,Hx,Hy)

X1 = randi([centre(2)-Hx,centre(2)+Hx], 1, num_particles); %width,���������
% ����һ�� 1 x Npop_particles ������������Ԫ��ֵΪ 1��scenes_size(2)֮��Ĳ����ľ��ȷֲ���������� 
X2 = randi([centre(1)-Hy,centre(1)+Hy], 1, num_particles);%height������
% ����һ�� 1 x Npop_particles ������������Ԫ��ֵΪ 1��scenes_size(2)֮��Ĳ����ľ��ȷֲ���������� 
X3 = zeros(1,num_particles);
X4 = zeros(1,num_particles);
X = [X1; X2; X3;X4];
