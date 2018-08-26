function print_console(console, new_msg)
currString = get(console,'String');
if size(currString) > 0
    currString{end+1} = newline;
end
currString{end+1} = new_msg;
set(console,'String',currString);
end

