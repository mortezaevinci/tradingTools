function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED;
KEY_IS_PRESSED  = event.Key;
disp('key is pressed')