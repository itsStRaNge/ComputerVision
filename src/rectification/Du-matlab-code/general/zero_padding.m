function str = zero_padding(number, strlength)

%ZERO_PADDING inserts zeros before the given number to make up the required length of characters.
%
%   str = zero_padding(number, strlength) returns the string containing
%   the input integer, number.  The string contains zeros inserted to the
%   front of the number to make up the required string length, strlength.
%
%   Example:
%     str = zero_padding(30, 5)
%   gives
%     str = '00030'
%
%Created December 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

if ~isposint(number) | ~isposint(strlength)
   error('zero_padding: number must be a positive integer');
end

str = sprintf('%d', number);
difflength = strlength-length(str);

for i=1:difflength
  str = strcat('0', str);
end
