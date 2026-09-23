function waitForInterruptC(ibDataHandler,interruptName,intrpTimeout)
d0=datetime();
while(ibDataHandler.Interrupt(interruptName)==0)
    pause(.1);
    d1=datetime();
    if (seconds(d1-d0)>intrpTimeout)
        break
    end
end

end