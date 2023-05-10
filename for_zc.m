function randzc = for_zc(m,D_r0)
randzc = zeros(1,m);
rv = 0;
z_num = m;
load klzercov.mat
ZC = ZC(1:m,1:m);
for x = 1:m
    rv = ZC(x,x);
    randzc(1,x) = sqrt(rv)*randn*(D_r0)^(5/6);
end