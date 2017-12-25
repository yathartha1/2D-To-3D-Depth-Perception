function A=KDTree(im,wi,he,dim,alpha,beta)

[rp,cp]=ind2sub([wi,he],1:wi*he);

ints=reshape(im,wi*he,dim)';
ri=(rp/sqrt(wi*wi+he*he)/100);
ci=(cp/sqrt(wi*wi+he*he)/100);

fets=[ints; [ri;ci]];

%temp_img=vl_kdtreequery(vl_kdtreebuild(fets),fets,fets,'NumNeighbors',20,'MaxComparisons',20);
temp_img=vl_kdtreequery(vl_kdtreebuild(fets),fets,fets,'NumNeighbors',20);
aaa=uint32(1:wi*he);
aa=repmat(aaa,20,1);

a=reshape(aa,[],1);
b=reshape(temp_img,[],1);


x1=fets(1:3,a);
x2=fets(1:3,b);
edist=(sum(abs(x1-x2)));

x1=fets(4:5,a);
x2=fets(4:5,b);
gdist=(sum(abs(x1-x2)));

finalw=exp(-alpha*edist-beta*gdist);

A=sparse(double(a),double(b),finalw,wi*he,wi*he);
A=A+A';
