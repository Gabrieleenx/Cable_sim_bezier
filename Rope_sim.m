clear all; close all; clc;
%%
num = 10; % number of nodes
L = 1; % lenght in meters
dL = L/num;
M = zeros(10); % inerial matrix
rho = 0.006; % line desity 
num_adj_idx = 1;% how many indeces are seen as adjacent  
A = {}; % includes Pj the is adjacent to Pi, does it include Pi? 
R_f = 0.02;
g = 9.81; % gravity 
for i = 1:num
    A_i = [];
    for j = max((i-num_adj_idx), 1):min((i+num_adj_idx), num)
        A_i= [A_i, j];
    end
    A{i} = A_i;
end

for i = 1:num
    for k = 1:num
        for z = 1:num
            rho_sum = 0;
            for j = A{i}
                for l = A{k}
                    rho_sum = rho_sum + rho;
                end
            end
            M(i,k) = M(i,k) + dL*rho_sum; % m_i,k
        end
    end
end

%%
alpha = [1;zeros(num-1,1)];

w = zeros(num,1);

X = zeros(num,num);
for i = 1:num
    for k = 1:num
        for j =1:num
            X(i,k) = X(i,k) + 0.5 * (M(k,j) - M(i,j))* w(j);
        end
    end
end


Y = zeros(num,num);
for i = 1:num
    for k = 1:num
        for j =1:num
            Y(i,k) = Y(i,k) - 0.5 * (M(i,k))* w(j);
        end
    end
end

K = zeros(num, num);

for i = 1:num
    for j = 1:num
        K(i,i) = K(i,i) + (R_f/dL);
        K(j,j) = K(j,j) + (R_f/dL);
        K(i,j) = K(i,j) - (R_f/dL);
        K(j,i) = K(i,j) - (R_f/dL);
    end
end

Theta = zeros(num,1);
G_t = zeros(num, 1);
for i = 1:num
    dy_dti = cos(Theta(i)); % not 100% sure 
    G_t(i) = G_t(i) + dL*rho*g*dy_dti;
end

my = ones(num,1)*0.01;
w_0 = zeros(num,1); 
Theta_0 = zeros(num,1);
% 
A = [M, alpha;
    alpha.', 0]
b = [X*w + Y*w - K*Theta - G_t;
    -2*my.'*w_0 - my.^2.' * Theta_0]
% new =  


