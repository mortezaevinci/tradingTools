%relative volume strengh
%absolute volume strength
function [rvs,avs]=largevolume(table,levelmultiplier,absolutevolumethreshold)
try
tt=zeros(size(table.Volume));
for i=1:4
    tt=tt+shift(table.Volume,i);
end

%rvs=[1;0;0;0;table.Volume(5:end)./(tt)./levelmultiplier(5:end)];

rvs=table.Volume./(tt)./levelmultiplier;
%rvs=shift(rvs,-4);
%if (~isempty(rvs))
%   rvs(1)=1; 
%end

avs=table.Volume/absolutevolumethreshold./levelmultiplier;
catch exception
dumpReport('error.log', exception)
rvs=zeros(size(table.Volume));
avs=zeros(size(table.Volume));
end
end