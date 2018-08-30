function M = imposeRank(M,r)

%IMPOSERANK imposes the rank constraint to a given matrix.
%
%   M = imposeRank(M,r)
%
%   imposes the rank constraint to the given matrix M and returns
%   a new matrix which has rank = r.
%
%Created April 1998.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

[n,m] = size(M);
nm = min([n,m]);
if r < nm
   [U,S,V] = svd(M,0);
   S(r+1:nm,r+1:nm) = zeros(nm-r,nm-r);
   M = U*S*V';
end
return
