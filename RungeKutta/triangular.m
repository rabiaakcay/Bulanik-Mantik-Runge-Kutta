%*****************************************************
% Triangular membership function
function triangular_membership = triangular(a,b,c,x)      
  mu1=(x-a)/(b-a);
  mu2=(c-x)/(c-b);
  mu3=0;
  triangular_membership = max(min(mu1,mu2),mu3);


