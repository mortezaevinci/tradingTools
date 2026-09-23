clear all

mdir='z:\My files\Project Trading\traderdata\data_other\obsolete\';

d='z:\My files\Project Trading\traderdata\data\';

files = dir(fullfile(d, '*.mat'));

for i=1:numel(files)
    clear tmfull
  if (  contains(files(i).name,' daily 5d'))
      fn=files(i).name;
    
         movefile([d fn],[mdir fn]);
  end
    
    
end