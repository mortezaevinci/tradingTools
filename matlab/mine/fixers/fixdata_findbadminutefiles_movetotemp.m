clear all

mdir='z:\My files\Project Trading\traderdata\data\tempbad4\';

d='z:\My files\Project Trading\traderdata\data\';

files = dir(fullfile(d, '*.mat'));

for i=1:numel(files)
    
  if (  contains(files(i).name,' minute') && ~contains(files(i).name,'today'))
      fn=files(i).name;
      load([d  fn]);
      
      if ((numel(tm.Close))>390 || numel(tm.Close)<385)
         movefile([d fn],[mdir fn]);
      end
  end
       
end