function [P,varargout] = canonical_P(P, Pind)

%CANONICAL_P converts the first projection matrix to the form [I 0].
%
%   [Pnew, T] = canonical_P(P)
%   [Pnew, T] = canonical_P(P, Pind)
%
%   Input arguments:
%   - P must be a 3-by-4-by-m matrix, where m >= 1, with P(:,:,i)
%     stores the projection matrix for the i-th view.
%   - Pind, if given, must be in the form that can be used in conjunction
%     with P.  If this second argument is used then {P,Pind} must conform
%     the matrix pair format designed by the Computer Vision group at the
%     School of Maths, Lund University.  Thus, P should be a 3-by-4m matrix
%     and Pind should be a 2-by-m matrix containing the indexing of columns
%     of matrix P.
%
%   Output arguments:
%   - If the input argument, Pind, is not used, then Pnew would be the new
%     3-by-4-by-m matrix, which has P(:,:,1) = [I 0].  If the argument
%     Pind is used then Pnew would have the same size as P and P(:,1:4) =
%     [I 0].
%   - T (optional argument) is the 4-by-4 transformation matrix that
%     maps P to Pnew:
%        i.e. Pnew(:,:,i) = P(:,:,i)*T
%          or Pnew(:,1:4) = P(:,1:4)*T
%     for all i
%
%Created in January 2004 by Du Huynh
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

if nargin < 2
   if size(P,1) ~= 3 | size(P,2) ~= 4
      error('canonical_P: P must be a 3-by-4-by-m matrix, where m >= 1');
   end
else
   if size(P,1) ~= 3 | mod(size(P,2),4) ~= 0
      error('canonical_P: P must be a 3-by-4m matrix, where m >= 1');
   end
end

t21 = randn(3,1);
PPinv = inv(P(:,1:3,1));
p = P(:,4,1);
T11 = PPinv*(eye(3)-p*t21');
t12 = -PPinv*p;
T = [T11 t12; t21' 1];

if nargin < 2
   P(:,1:4,1) = [eye(3) zeros(3,1)];
   for i=2:size(P,3)
      P(:,:,i) = P(:,:,i)*T; 
   end
else
   [Pnew,Pindnew] = nyml;
   [Pnew,Pindnew] = laggtillml(Pnew,Pindnew, [eye(3) zeros(3,1)]);
   for i=2:size(Pind,2)
      PP = plockaurml(P,Pind,i);
      PP = PP*T;
      [Pnew,Pindnew] = laggtillml(Pnew,Pindnew,PP);
   end
   P = Pnew;
end

if nargout > 1
   varargout{1} = T;
end

return