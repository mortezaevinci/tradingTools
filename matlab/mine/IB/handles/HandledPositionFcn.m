function output=HandledPositionFcn(src,event)

ms=src.PositionMessages;

for i=0:ms.Count-1
    m=ms.Item(i);
disp(['POSITION account=' m.Account.char ' ' m.Contract.ToString().char ' ' num2str(m.Position) ' x ' num2str(m.AverageCost)]);
end


end