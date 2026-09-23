function [xup, xdn]=crossPivot(datatable,pivot)
try
    compup=datatable.Close>datatable.Open & [1;datatable.Open(1:end-1)<datatable.Close(2:end)];
compdn=datatable.Close<datatable.Open & [1;datatable.Open(1:end-1)>datatable.Close(2:end)];
x1up=datatable.Close>pivot & datatable.Low<pivot;
x1dn=datatable.High>pivot & datatable.Close<pivot;
x1up(end)=(datatable.High(end)>pivot & datatable.Low(end)<pivot);
x1dn(end)=(datatable.High(end)>pivot & datatable.Low(end)<pivot);

xup=(x1up & compup).*datatable.High;
xdn=(x1dn & compdn).*datatable.Low;
catch exception
getReport(exception,'extended','hyperlinks','off')
xdn=zeros(size(datatable.Date));
xup=zeros(size(datatable.Date));
end
end