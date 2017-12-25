function A=KNN(im,wi,he,dim,alpha,beta)

[rp,cp]=ind2sub([wi,he],1:wi*he);

ints=reshape(im,wi*he,dim)';
ri=(rp/sqrt(wi*wi+he*he)/100);
ci=(cp/sqrt(wi*wi+he*he)/100);

fets=[ints; [ri;ci]];

fets= fets';
temp_img= knnsearch(fets,fets,'k',20);
fets= fets';
temp_img = temp_img';

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