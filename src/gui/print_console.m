function print_console(console, new_msg)
%currString = get(console,'String');
%str = sprintf('%s\n%s', currString, new_msg);
fprintf(new_msg);
if console ~= 0
    set(console,'String',new_msg);
    drawnow;
end
end

