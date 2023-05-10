function [n,m] = nmzern(nz)
%����nmzern(nz)�������nz������˶���ʽ��Ӧ�Ķ���ʽָ��n�ͽ���Ƶ��m

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
