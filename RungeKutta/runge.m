%**********************************************************
% Runge Kutta Function
% A  : state matrix
% B  : input coefficient vector
% U  : input vector
% X0 : initial values
% dt : increment time
function [x]=runge(A,B,U,X0,dt)

SIZE=size(A);  
LS=SIZE(1); 
LK=SIZE(2);

%Step 1
for n=1:LS
    x0(n)=X0(n);
    AA1(n)=0;
end
for n=1:LS
    for m=1:LK
        AA(n,m)=A(n,m)*x0(m);
        BB(n)=B(n,n)*U(n);
     end
end
for q=1:LS
    AA1(q)=AA1(q)+ dt*(sum(AA(q,:))+sum(BB(q)));
end

%Step 2
for n=1:LS
    x0(n)=X0(n)+AA1(n)/2;
    BB1(n)=0;
end
for n=1:LS
    for m=1:LK
        AA(n,m)=A(n,m)*x0(m);
        BB(n)=B(n,n)*U(n);
     end
end
for q=1:LS
    BB1(q)=BB1(q)+ dt*(sum(AA(q,:))+sum(BB(q)));
end

%Step 3
for n=1:LS
    x0(n)=X0(n)+BB1(n)/2;
    CC1(n)=0;
end
for n=1:LS
    for m=1:LK
        AA(n,m)=A(n,m)*x0(m);
        BB(n)=B(n,n)*U(n);
     end
end
for q=1:LS
    CC1(q)=CC1(q)+ dt*(sum(AA(q,:))+sum(BB(q)));
end

%Step 4
for n=1:LS
    x0(n)=X0(n)+CC1(n);
    DD1(n)=0;
end
for n=1:LS
    for m=1:LK
        AA(n,m)=A(n,m)*x0(m);
        BB(n)=B(n,n)*U(n);
     end
end
for q=1:LS
    DD1(q)=DD1(q)+ dt*(sum(AA(q,:))+sum(BB(q)));
end

%Result 
for n=1:LS
    x(n)=X0(n)+(AA1(n)+2*BB1(n)+2*CC1(n)+DD1(n))/6;
end
