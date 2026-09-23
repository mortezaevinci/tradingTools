function output=HandledOrderStatusFcn(src,event)

osms=src.OrderStatusMessages;

for i=1:osms.Count-1
    osm=osms.Item(i);
disp(['ORDERSTATUD ID=' num2str(osm.OrderId) ' ' osm.Status.char ' filled:' num2str(osm.Filled) ' remaining:' num2str(osm.Remaining )]);
end

end