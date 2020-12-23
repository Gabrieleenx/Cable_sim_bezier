function [P1, C1, P2, C21, C22, P3, C3] = curve_bezer(P1, rot_1, P3, rot_2, stiffnes, mass, length)
    tic
    unit_v = [1;0;0];
    length_tol = 0.02;
    g = 9.82;
    stiffnes = stiffnes * length;
    rotm_1 = RotM_3D(rot_1);
    rotm_2 = RotM_3D(rot_2);

    C1 = P1 + rotm_1*unit_v .* stiffnes; 
    C3 = P3 - rotm_2*unit_v .* stiffnes; 

    C1_ = P1 + rotm_1*unit_v .* stiffnes*(1+ 0.2*norm(C1-C3,2)); 
    C3_ = P3 - rotm_2*unit_v .* stiffnes*(1 + 0.2 * norm(C1-C3,2)); 
    % low energy position 

    P2_start = (P1 + P3)/2;

    internal_forces = 4*((C1-P1) + (C3-P3))/2;

    gravity = 0.5*length*(1-stiffnes) * mass * [0;0;-g];

    P2 = P2_start + internal_forces + gravity;%[0.5; 0; 0.4];
    
    P_diff = (P3-P1)/norm(P3-P1);
    a = C3_-C1_;
    a = a/norm(a);
    if norm(a-P_diff) >1.95 || sum(isnan(a))
        a = P_diff;
    end
    a_old = a;
    C21 = P2 - a*length/6;%Rotm.'*unit_v .* length/6; 
    C22 = P2 + a*length/6; %Rotm.'*unit_v .* length/6;    
    curve_L = curve_length(P1, C1, P2, C21, C22, P3, C3, 30);
    offest = 1;
    itter = 1;
    
    while curve_L < length-length*length_tol || curve_L > length+length*length_tol
        step = abs(length-curve_L)* 8/sqrt(itter);
        if step < 0.02
            step = 0.02;
        end
        if step > 0.2
            step = 0.2;
        end
        if curve_L < length
            offest = offest + step; % fix dynamic 
            P2 = P2_start + offest* internal_forces + (1+ (offest-1))*gravity;
        elseif curve_L > length
            offest = offest - step;
            if offest < 0
                offest
                break;
            end
            P2 = P2_start + offest * internal_forces + (1+ (offest-1)) * gravity;
        end
        itter = itter +1;
        if itter >100
           offest = offest
           curve_L = curve_length(P1, C1, P2, C21, C22, P3, C3, 30)
           error('too many ittersations ')
        end
        
        C1 = P1 + rotm_1*unit_v .* stiffnes* (1 + (offest-1)*0.2); 
        C3 = P3 - rotm_2*unit_v .* stiffnes* (1 + (offest-1)*0.2); 
        C1_ = P1 + rotm_1*unit_v .* stiffnes*(1+ 0.2*norm(C1-C3,2))* (1 + (offest-1)*0.2); 
        C3_ = P3 - rotm_2*unit_v .* stiffnes*(1 + 0.2 * norm(C1-C3,2))* (1 + (offest-1)*0.2); 

        a = C3_-C1_;
        a = a/norm(a);
        if norm(a-a_old,2) > 1 || sum(isnan(a))
            a = a_old;
        end
        a_old = a;

        C21 = P2 - a*length/6 ;% Rotm.'*unit_v .* length/6; 
        C22 = P2 + a*length/6  ;% Rotm.'*unit_v .* length/6;    
        curve_L = curve_length(P1, C1, P2, C21, C22, P3, C3, 30);
    end 

    toc
    
end
