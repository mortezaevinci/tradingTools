pressed_leftarrow=0;
pressed_rightarrow=0;
pressed_newsymbol=0;
try
if (~isempty(PRESSEDKEY))
    for i=1:numel(PRESSEDKEY)
        if (~isempty(PRESSEDKEY{i}))
            if (strcmp(PRESSEDKEY{i},'leftarrow'))
            
                pressed_leftarrow=1;
            end
            if (strcmp(PRESSEDKEY{i},'rightarrow'))
              
                pressed_rightarrow=1;
            end
            
             
            if (numel(PRESSEDKEY{i})==1 && PRESSEDKEY{i}>='0' && PRESSEDKEY{i}<='9')
                selectedchannel_char=[selectedchannel_char PRESSEDKEY{i}];
                if (numel(selectedchannel_char)>2)
                    selectedchannel_char=selectedchannel_char((end-1):end);
                end
                selectedchannel=str2num(selectedchannel_char);
                if (isempty(selectedchannel))
                    selectedchannel=0;
                end
                if (selectedchannel>nrunningcontracts)
                    selectedchannel=0;
                end
               
                
                selectedchannelupdated=0;
            end
            
            if ((numel(PRESSEDKEY{i})==1 && PRESSEDKEY{i}>='a' && PRESSEDKEY{i}<='z') || strcmp(PRESSEDKEY{i},'leftbracket')==1 || strcmp(PRESSEDKEY{i},'rightbracket')==1)
                if (strcmp(PRESSEDKEY{i},'leftbracket')==1)
                    newsymbol='';
                elseif (strcmp(PRESSEDKEY{i},'rightbracket')==1)
                    newsymbol
                    %process new symbol
                   pressed_newsymbol=1;
                else
                    newsymbol=[newsymbol PRESSEDKEY{i}]
                end
              
            end
            
            
            
        else
            
           
        end
    end
end
PRESSEDKEY=[];

catch exception
   dumpReport('error.log', exception) 
end
