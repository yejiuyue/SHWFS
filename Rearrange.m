function [c] = Rearrange(c,aryuValueAry)
%REARRANGE Summary of this function goes here
%   Detailed explanation goes here
%aryuValueAry(isnan(aryuValueAry))=0;
A=sum(aryuValueAry,1);
numb=size(A,2);
k1=1;
B=[];
for i=1:numb
    if A(:,i)~=0
        k1=A(:,i)+k1;
        C=c(k1-A(:,i):k1-1,:);
       B=sortrows(C,2);
       c(k1-A(:,i):k1-1,:)=B;
      
end
end
end

