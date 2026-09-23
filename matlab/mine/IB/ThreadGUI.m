function ThreadConnectIb(threadManagers,setup)
FS = stoploop(setup.name,{'Stop me for', setup.name}) ;
while(threadManagers.GUI.run)
    % list all signalQ;s
	

	if (FS.Stop())
		threadManagers.GUI.run=0;
		threadManagers.requestSnapshots.run=0;
		pause(2);%xxxmor, there should be some sort of .join here
		threadManagers.manageOrders.run=0;
		pause(5);%xxxmor, there should be some sort of .join here
		threadManagers.connectIb.run=0;
        break;
    end
    
    pause(1);
end

FS.Clear() ; % Clear up the box
clear FS ; % this structure has no use anymore

end