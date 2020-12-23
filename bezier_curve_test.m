clear all; close all; clc
%%
stiffnes = 0.05;
unit_v = [1;0;0];
mass = 0.05;
g = 9.82;
length = 0.5;
length_tol = 0.02;

%%

xpos = linspace(0.4, 0.1, 50);
ypos = linspace(0, 0.2, 50);
zpos = linspace(0, -0.2, 50);

rot_1_y = linspace(-0.8, 0.8, 50);

figure
for i = 1:50
    
    P1 = [0; 0; 0];
    P3 = [xpos(i); ypos(i); zpos(i)];
    euler_rot_1 = [0; -rot_1_y(i); 0]; % x,y,z
    euler_rot_2 = [0; rot_1_y(i); 0];
    
    [P1, C1, P2, C21, C22, P3, C3] = curve_bezer(P1, euler_rot_1, P3, euler_rot_2, stiffnes, mass, length);
    plot_curve(P1, C1, P2, C21, C22, P3, C3);
    drawnow;
    pause(0.01)

end
done = 1

%%

function plot_curve(P1, C1, P2, C21, C22, P3, C3)
    res= 50;
    t = linspace(0,1,res);
    P = zeros(3, res);

    for i = 1:res
        P(:,i) = curve(P1, C1, P2, C21, C22, P3, C3, t(i));
    end

    L = curve_length(P1, C1, P2, C21, C22, P3, C3, 30);

    plot3(P(1,:),P(2,:),P(3,:))
    hold on
    %plot3(C1(1),C1(2),C1(3), 'r*')
    %plot3(C3(1),C3(2),C3(3), 'g*')
    %plot3(C21(1),C21(2),C21(3), 'b*')
    %plot3(C22(1),C22(2),C22(3), 'b*')
    axis equal
    xlim([0 0.5])
    ylim([-0.4 0.4])
    zlim([-0.4 0.4])
    title(string(L))
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold off

end






