function L = curve_length(P1, C1, P2, C21, C22, P3, C3, N)
t = linspace(0,1,N);
L = 0;

P1 = curve(P1, C1, P2, C21, C22, P3, C3, t(1));
for i = 2:N
    P2 = curve(P1, C1, P2, C21, C22, P3, C3, t(i));
    L = L + norm(P1-P2,2);
    P1=P2;
end
end
