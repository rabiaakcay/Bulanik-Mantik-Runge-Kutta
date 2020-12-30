%*************************************
% Limiter function 
% Enables a variable to fall between its upper and lower limits
function y=limiter(lower,upper,x)
if x <= lower
   y=lower;
elseif x>= upper
   y=upper;
else
   y=x;
end
