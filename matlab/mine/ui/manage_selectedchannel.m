%tic
if (selectedchannel==0)

   %show all again
   for jj=1:nrunningcontracts
       if (selectedchannelupdated==0)
      panel{jj}.Position=panelPosition{jj};
      panel{jj}.Visible=true; 
       end
      looperEngine.layout{jj}.extended=0;
   end
   selectedchannelupdated=1;
end

 
% one symbol is selected
if (selectedchannel>0 )
    if (selectedchannelupdated==0)
    for jj=1:nrunningcontracts
     
      panel{jj}.Visible=false; 
    end
   selectedri=selectedchannel;
   
   panel{selectedri}.Position=[0 0 1 1];
   panel{selectedri}.Visible=true;
   selectedsi=looperEngine.runIndices(selectedri);
   
     selectedchannelupdated=1;
    end
     looperEngine.layout{selectedchannel}.extended=1;
end



%ticmanagechannels=toc