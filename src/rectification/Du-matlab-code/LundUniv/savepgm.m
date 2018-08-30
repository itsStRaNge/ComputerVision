function status = savepgm(image,filename,scaling);
%
% SAVEPGM    Saves a matrix as a grayscale image in pgm-format.
%            If the values of the matrix is within the range of 0..255,
%            (or 1..256, in which case ONE is subtracted)
%            the values are truncated to the nearest integer less or equal
%            to the value. Otherwise the values are first scaled to fit
%            the range of 0..255. Scaling can also be forced.
%
%            SAVEPGM(IMAGE) saves the matrix IMAGE to a file called
%            'matlab_image.pgm', scaled if neccessary.
%
%            SAVEPGM(IMAGE,'filename.pgm') saves the matrix IMAGE to
%            the file 'filename.pgm', scaled if neccessary.
%
%            SAVEPGM(IMAGE,'filename.pgm',FORCE_SCALING) saves the matrix
%            IMAGE to the file 'filename.pgm', scaled  if FORCE_SCALING
%            is true (i.e. 1), and truncated if FORCE_SCALING is false
%            (i.e. 0).
%
%            See also READPGM.
%

if nargin > 3,  error('Too many arguments to savepgm'); end;
if nargin == 3, force_scaling = (1==1); end;   %TRUE
if nargin < 3,  scaling = 0;                   % dummy
                force_scaling = (1==2); end;   % FALSE
if nargin < 2,  filename = 'matlab_image.pgm'; end
if nargin < 1,  error('Too few arguments to savepgm'); end

%disp('Warning, new version, see "help savepgm".');

image = image';
[width,height] = size(image);

maxval = max(max(image));
minval = min(min(image));

if minval > 0,
  image = image-1;                % Move 1..256 to 0..255
  maxval = max(max(image));
  minval = min(min(image));
end

if (force_scaling & scaling) |  ((minval <  0 | maxval >  255) & ~force_scaling),
  disp('Scaling to 0..255 intervall');
  if maxval == minval,
    intimage = image*0+128;
  else
    intimage = floor(255.99*(image-minval)/(maxval-minval));
  end
else
  intimage = floor(min(max(zeros(width,height),image),255*ones(width,height)));
end

fwid = fopen(filename,'w');
fprintf(fwid,'P5\n');
fprintf(fwid,'%d %d\n',width,height);
fprintf(fwid,'255\n');
fwrite(fwid,intimage,'uchar');
if nargout == 0,
  fclose(fwid);
else
  status = fclose(fwid);
end