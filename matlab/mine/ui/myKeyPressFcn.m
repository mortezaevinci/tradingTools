function myKeyPressFcn(hObject, event)
global PRESSEDKEY;
if (isempty(PRESSEDKEY))
PRESSEDKEY  = {event.Key};
else
PRESSEDKEY{end+1}=event.Key;
end
disp(['key ' event.Key ' pressed']);