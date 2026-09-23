clear all

mdir='z:\My files\Project Trading\traderdata\data\tempbad\';

d='z:\My files\Project Trading\traderdata\data\';

files = dir(fullfile(d, '*.mat'));

for i=1:numel(files)
    
  if (  contains(files(i).name,' minute') && ~contains(files(i).name,'today'))
      fn=files(i).name;
      load([d  fn]);
      
      if (size(tm,1)~=390)
      
     if (size(tm,1)<390 && size(tm,1)>380)
         [tm2,success]=fixMinuteDataMissingPoint(tm);
        if (success)
            tm=tm2;
        end
     end
    if (exist('tmfull'))
    save([d  files(i).name],'tm','tmfull','jmfull');
    else
        save([d  files(i).name],'tm','jm');
    end
      end
  end
    
    
end