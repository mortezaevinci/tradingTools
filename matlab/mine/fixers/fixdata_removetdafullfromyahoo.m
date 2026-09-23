clear all

d='z:\My files\Project Trading\traderdata\data\';

dirs=dir(d);
dirs(~[dirs.isdir]) = [];
for j=1:numel(dirs)
    newd=[d dirs(j).name '\'];
    fd=fullfile(newd, '*.mat');
files = dir(fd);
for i=1:numel(files)
    clear version;
    clear tmfull;
  if (  contains(files(i).name,' minute') && ~contains(files(i).name,'today'))
      fn=files(i).name;
      
      load([newd  fn]);
          %up to this point in time, only TDA has tmfull, so this is a tda
          %data
          if (exist('version')==1 && strcmp(version,'yahoo+tda')==1)
          %remove tda-based tmfull
         
               version='yahoo+tda';
              save([newd  fn],'tm','version');
   
                   
          end
 
  end
    
    
end

end