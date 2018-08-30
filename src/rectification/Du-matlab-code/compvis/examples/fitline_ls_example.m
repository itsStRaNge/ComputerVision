%fitline_ls_example
%
%   An example on line fitting.
%
%Created September 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% create two seed points
pt = rand(2,2)*100-50;
npts = 10;
alpha = rand(1,npts);
% create points that are linear combination of the two seed points
xy(1,1:npts) = pt(1,1)*alpha + pt(1,2)*(1-alpha);
xy(2,1:npts) = pt(2,1)*alpha + pt(2,2)*(1-alpha);


% add small gaussian noise to coordinates of the points
sigma = kb_input('Enter standard deviation of noise (default=0.1): ', 0.1);
noise = randn(2,npts)*sigma;
xyn = xy + noise;
xyn = [xyn; ones(1,npts)];

figure, hold on
plot(xy(1,:), xy(2,:), 'r*')
plot(xyn(1,:), xyn(2,:), 'g.')
xlist = linspace(min(xy(1,:)), max(xy(1,:)), 10);

[abc,errs,avgerr] = fitline_ls(xyn, []);
a = abc(1);  b = abc(2);  c = abc(3);

fprintf('With scaling...\n');
fprintf('a = %f, b = %f, c = %f, avgerr = %f\n\n', a, b, c, avgerr);

ylist = -(a*xlist + c) / b;
tmp1=plot(xlist, ylist, 'b-');

[abc,errs,avgerr] = fitline_ls(xyn, [], 0);
a = abc(1);  b = abc(2);  c = abc(3);

fprintf('Without scaling...\n');
fprintf('a = %f, b = %f, c = %f, avgerr = %f\n\n', a, b, c, avgerr);

ylist = -(a*xlist + c) / b;
tmp2=plot(xlist, ylist, 'c-');

legend([tmp1,tmp2], 'With scaling', 'Without scaling');


