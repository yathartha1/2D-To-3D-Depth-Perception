function [node,edge]=creategraph(X,Y)

N=X*Y;
rx=0:(X-1);
ry=0:(Y-1);
[x,y]=meshgrid(ry,rx);
node=[x(:),y(:)];

edge=[[1:N]',[(1:N)+1]'];
edge=[[edge(:,1);[1:N]';[1:N]'],[edge(:,2);[1:N]'+X;[1:N]'+Y]];
exclude=find((edge(:,1)>N)|(edge(:,1)<1)|(edge(:,2)>N)|(edge(:,2)<1));
edge([exclude;[X:X:((Y-1)*X)]'],:)=[];