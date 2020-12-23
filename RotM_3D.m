function rotm = RotM_3D(xyz)
    x = xyz(1);
    y = xyz(2);
    z = xyz(3);
    R_x = [1, 0, 0;0, cos(x), -sin(x); 0, sin(x), cos(x)];
    R_y = [cos(y), 0 ,sin(y); 0,1,0; -sin(y), 0, cos(y)];
    R_z = [cos(z), -sin(z), 0; sin(z), cos(z), 0; 0, 0, 1];
    rotm = R_x*R_y*R_z;
end
