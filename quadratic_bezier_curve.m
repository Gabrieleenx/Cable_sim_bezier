function P = quadratic_bezier_curve(P1, C1, P2, C2, t)
    Q1 = P1 + t*(C1-P1);
    Q2 = C1 + t*(C2-C1);
    Q3 = C2 + t*(P2-C2);
    
    R1 = Q1 + t*(Q2-Q1);
    R2 = Q2 + t*(Q3-Q2);
    
    P = R1 + t*(R2-R1);

end
