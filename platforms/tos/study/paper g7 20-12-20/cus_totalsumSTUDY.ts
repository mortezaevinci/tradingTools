
rec Data;

if (close==0) then
{
if (high>-low)
{
Data=Data[1]+high;
}
else
{
Data=Data[1]+low;
}
}
else
{
Data=Data[1]+close;
}

plot pData=Data;