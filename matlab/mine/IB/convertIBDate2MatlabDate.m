function [mdate] = convertIBDate2MatlabDate(ibdate)

mdate=[ibdate(1:4) '-' ibdate(5:6) '-' ibdate(7:8) ' ' ibdate(11:end)];

end

