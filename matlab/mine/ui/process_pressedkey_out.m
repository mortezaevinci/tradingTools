pressed_scape=0;
for i=1:numel(PRESSEDKEY)

if (~isempty(PRESSEDKEY{i}))
    if (strcmp(PRESSEDKEY{i},'escape')==1)
        pressed_scape=1;
        PRESSEDKEY={};
        break;
    end
end
end