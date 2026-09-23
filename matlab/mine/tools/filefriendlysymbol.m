function str=filefriendlysymbol(str)

%str=replace(str,'^','_');
str=replace(str,':','_');
str=replace(str,'/','_');
str=replace(str,'=','_');

end