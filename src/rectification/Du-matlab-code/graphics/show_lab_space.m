%A Matlab script for plotting the a*b* space where L* = 75, 50, and 25.
%
%May 2010
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering


figure;
Lvalues = [75; 50; 25];

for ii=1:length(Lvalues)
    rgbim = compute_lab_space(Lvalues(ii));
    subplot(2,2,ii); imagesc(-128:128, -128:128, rgbim);
    set(gca, 'FontSize', 14);
    xlabel('a*', 'FontSize', 18);
    ylabel('b*', 'FontSize', 18);
    title(sprintf('L* = %d', Lvalues(ii)), 'FontSize', 18);
    axis xy; axis equal; axis tight;
end
set(gcf, 'Position', [10, 10, 890, 890]);

% The L*a*b* colour space is larger than the RGB colour space. The black
% regions in the subplots denote L*a*b* values that do not correspond to
% RGB values in the range 0..255 and thus cannot be displayed.