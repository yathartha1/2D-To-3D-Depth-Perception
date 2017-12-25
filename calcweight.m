function W=calcweight(edge,values,m,n,alpha)

intensitydiff=sqrt(sum((values(edge(:,1),:)-values(edge(:,2),:)).^2,2));
intensitydiff=Normalize(intensitydiff);
localweight=exp(-alpha*intensitydiff);
W=sparse([edge(:,1);edge(:,2)],[edge(:,2);edge(:,1)],[localweight;localweight],m*n,m*n);