function ok = fitline_condfunc(data)

%FITLINE_CONDFUNC checks condition of input data.
%
%   ok = fitline_condfunc(data)
%
%   When a random sample of data points is chosen for line fitting,
%   this function should be used to inspect for possible degeneracy
%   of the sample.  For line fitting, the only condition imposed
%   is that the image points must be at least 20 pixels apart.
%     
%   SEE ALSO fitline_ls, lmeds, lmeds_options
%
%Created 2000.
%Last modified September 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

if size(data,1) ~= 3 & size(data,2) <= 2
   error('fitline_condfunc: data must have 2 rows and at least 2 columns');
end

xy = pflat(data(1:3,:));
if norm(xy(1:2,1) - xy(1:2,2), 2) < 20
   ok = 0;
else ok = 1;
end

return
