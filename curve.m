function P = curve(P1, C1, P2, C21, C22, P3, C3, t)
    if t < 0.5
        P = quadratic_bezier_curve(P1,C1, P2, C21,t*2);
    else
        P = quadratic_bezier_curve(P2,C22, P3, C3,(t-0.5)*2);
    end
end

    