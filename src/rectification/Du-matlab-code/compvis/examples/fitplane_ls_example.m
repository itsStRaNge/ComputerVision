%fitplane_ls_example
%
%   An example on plane fitting.
%
%Created September 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% create two seed points
pt = rand(3,3)*100-50;
npts = 10;
alpha = rand(1,npts);
beta = rand(1,npts);
% create points that are linear combination of the two seed points
for i=1:3
   xyz(i,1:npts) = pt(i,1)*alpha + pt(i,2)*beta + pt(i,3)*(1-alpha-beta);
end

% add small gaussian noise to coordinates of the points
sigma = kb_input('Enter standard deviation of noise (default=0.1): ', 0.1);
noise = randn(3,npts)*sigma;
xyzn = xyz + noise;
xyzn = [xyzn; ones(1,npts)];

[abcd,errs,avgerr] = fitplane_ls(xyzn, []);
a = abcd(1);  b = abcd(2);  c = abcd(3);  d = abcd(4);

fprintf('With scaling...\n');
fprintf('a = %f, b = %f, c = %f, d = %f, avgerr = %f\n\n', a, b, c, d, avgerr);

[abcd,errs,avgerr] = fitplane_ls(xyzn,[],0);
a = abcd(1);  b = abcd(2);  c = abcd(3);  d = abcd(4);

fprintf('Without scaling...\n');
fprintf('a = %f, b = %f, c = %f, d = %f, avgerr = %f\n\n', a, b, c, d, avgerr);


