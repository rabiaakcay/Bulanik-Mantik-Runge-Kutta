%*****************************************
% Triangular membership sub program 
% sub program for  fuzzification
function FS=triangular_membership(N,Z,P,X)
	   if X <= N(2)
          FS(1) = 1;
          FS(2) = 0.0;
   		  FS(3) = 0.0;
	    elseif X <= Z(1)
          FS(1) = abs((X-N(3)))/abs(N(2)-N(3));
          FS(2) = 0.0;
   		  FS(3) = 0.0;
        elseif X <= N(3)
          FS(1) = abs(X-N(3))/abs(N(2)-N(3));
          FS(2) = abs(X-Z(1))/abs(Z(2)-Z(1));
   		  FS(3) = 0.0;
	    elseif X <= Z(2)
          FS(1) = 0;
          FS(2) = abs(X-Z(1))/abs(Z(2)-Z(1));
		  FS(3) = 0.0;
	    elseif X <= P(1)
          FS(1) = 0;
          FS(2) = abs(X-Z(3))/abs(Z(2)-Z(3));
   		  FS(3) = 0.0;
	    elseif X <= Z(3)
          FS(1) = 0.0;
		  FS(2) = abs(X-Z(3))/abs(Z(2)-Z(3));
	      FS(3) = abs(X-P(1))/abs(P(2)-P(1));
 	    elseif X <= P(2)
          FS(1) = 0.0;
		  FS(2) = 0.0;
	      FS(3) = abs(X-P(1))/abs(P(2)-P(1));
       else
          FS(1) = 0.0;
          FS(2) = 0.0;
          FS(3) = 1.0;
   	   end
