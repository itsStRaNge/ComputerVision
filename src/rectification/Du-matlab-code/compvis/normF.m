%normF normalizes a fundamental matrix so that the 3rd column has magnitude 1.
%
%F = normF(F)
%
%   A function that normalizes the fundamental matrix, F, such that
%   the 3rd column of F has magnitude = 1.  If the 3rd column of F has
%   magnitude less than 1e5 then no scaling would be applied and 
%   scaledF = F.
%
% Du Huynh, created as a Maple file on 30 March 1996
% Du Huynh, converted to Matlab in August 1999

function F = normF(F)

norm_f3 = norm(F(:,3), 2);
   
% if the norm of f3 is too small for safe scaling, then do not scale
if norm_f3 > 10^(-5)
   scaledF = F / norm_f3;
else
   scaledF = F;
end
return