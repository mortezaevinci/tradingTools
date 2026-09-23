clear all

mdir='z:\My files\Project Trading\traderdata\data\tempgood\';

d='z:\My files\Project Trading\traderdata\data\';

files = dir(fullfile(d, '*.mat'));

for i=1:numel(files)
    clear tmfull
  if (  contains(files(i).name,' minute') && ~contains(files(i).name,'today')  && ~contains(files(i).name,'$')   && ~contains(files(i).name,'^'))
      fn=files(i).name;
      load([d  fn]);
     
     if (exist('tmfull'))
         movefile([d fn],[mdir fn]);
     end
  end
    
    
end