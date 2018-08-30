function val = kb_input(str, default_val)

%KB_INPUT reads a value (number(s) or string) from keyboard.
%
%   val = kb_input(str, default_val) prints the string, str, to standard
%   output to prompt the user for input.  The second argument, default_val,
%   is optional and is useful when the user chooses the supplied default value.
%   Examples:
%      filename = kb_input('Enter the name of the input file (default=input.dat): ',...
%                 'input.dat');
%      If the user presses <ENTER> then filename='input.dat'
%
%      thres = kb_input('Enter the threshold value (default=5): ', 5);
%      If the user enters 4 then thres=4; if the user presses <ENTER> then thres=5.
%
%      thres = kb_input('Enter the threshold value: ');
%      is identical to
%      thres = input('Enter the threshold value: ');
%
%      numlist = kb_input('Enter a list of numbers (default=[1 2 3]): ', [1 2 3]);
%      If the user presses <ENTER> then numlist=[1 2 3]
%
%Created 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

if nargin > 1
   if isstr(default_val)
      val = input(str, 's');
   else
      val = input(str);
   end   
   if isempty(val)
      val = default_val;
   end
else
   val = input(str);
end

return
