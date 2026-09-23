function [xup,xdn]=crossPivot2(datatable,pivot)
try
    compup=datatable.Close>pivot;
compdn=datatable.Close<pivot;
x1=datatable.High>pivot & datatable.Low<pivot;
x2u=shiftpad(datatable.High,1)<datatable.Open;
x2d=shiftpad(datatable.Low,1)>datatable.Open;


xup=((x1|x2u) & compup).*pivot;
xdn=((x1|x2d) & compdn).*pivot;
catch exception
dumpReport('error.log', exception)
xdn=zeros(size(datatable.Date));
xup=zeros(size(datatable.Date));
end
end