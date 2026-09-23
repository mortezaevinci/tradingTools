function myKeyPressFcn(hObject, event)
global RELEASEDKEY;
RELEASEDKEY  = event.Key;
%disp(['key ' RELEASEDKEY ' released']);