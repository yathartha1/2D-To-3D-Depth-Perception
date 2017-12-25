function newVals=dirichlet(L,indexed,bound)

N=length(L);
nonIndexed=1:N;
nonIndexed(indexed)=[];
bound=double(bound);
nonIndexed=double(nonIndexed);
indexed=double(indexed);

B=-L(nonIndexed,indexed)*(bound);
%x=L(nonIndexed,nonIndexed)\B;

P = ichol(L(nonIndexed,nonIndexed), struct('michol','on'));
[x,~,~,~,~] = pcg(L(nonIndexed,nonIndexed),B,1e-6,300,P,P');

h=mean(x);
disp(h);
newVals=zeros(size(bound));
newVals(indexed,:)=bound;
newVals(nonIndexed,:)=x;