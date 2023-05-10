function [n,m] = nmzern(nz)
%函数nmzern(nz)计算出第nz阶泽尼克多项式对应的多项式指数n和角向频率m

    csum = cumsum(1:nz);
    n = sum(csum < nz);
    if n==0 
        m=0;
    elseif mod(n,2)==0
        m=fix((nz-csum(n))/2)*2;
    elseif mod(n,2)==1
        m=round((nz-csum(n))/2)*2-1;
    end
return
