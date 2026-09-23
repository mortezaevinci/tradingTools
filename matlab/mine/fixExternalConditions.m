function fixExternalConditions(ibWrapper,ibDataHandler,od,cd,contractTriggers,ci,conIdMap,tradedate)

nec=od.externalConditions.Count;
for eci=0:nec-1
    ec=od.externalConditions.Item(eci);
    if (isempty(ec.contractDefinition.contract.Symbol))
        ec.contractDefinition.contract=cd.contract;
        
        %setConId(ibWrapper,ec.contractDefinition,ibDataHandler,conIdMap);
        
    end
    
 
    
    if (strcmp(ec.thresholdType.char,'EntryStp'))
        ec.parameters(1)=round(contractTriggers.ThEntryStp(ci),2);
    end
    if (strcmp(ec.thresholdType.char,'EntryLmt'))
        ec.parameters(1)=round(contractTriggers.ThEntryLmt(ci),2);
    end
     if (strcmp(ec.thresholdType.char,'Target'))
        ec.parameters(1)=round(contractTriggers.ThTarget(ci),2);
     end
     if (strcmp(ec.thresholdType.char,'Vol'))
        ec.parameters(1)=round(contractTriggers.ThVol(ci),0);
     end
      if (strcmp(ec.thresholdType.char,'DiffVolMax'))
        ec.parameters(1)=round(contractTriggers.ThDiffVolMax(ci),0);
      end
      if (strcmp(ec.thresholdType.char,'DiffVolAve'))
        ec.parameters(1)=round(contractTriggers.ThDiffVolAve(ci),0);
      end
      if (strcmp(ec.thresholdType.char,'TrailAmt'))
        ec.parameters(1)=round(contractTriggers.ThTrailAmt(ci),2);
      end
       if (strcmp(ec.thresholdType.char,'Target1'))
        ec.parameters(1)=round(contractTriggers.ThTarget1(ci),2);
       end
       if (strcmp(ec.thresholdType.char,'Target2'))
        ec.parameters(1)=round(contractTriggers.ThTarget2(ci),2);
       end
       if (strcmp(ec.thresholdType.char,'TrailAmt'))
        ec.parameters(1)=round(contractTriggers.ThTrailAmt(ci),2);
       end
       if (strcmp(ec.thresholdType.char,'LmtOfStp'))
        ec.parameters(1)=round(contractTriggers.ThLmtOfStp(ci),2);
       end
       if (strcmp(ec.thresholdType.char,'MAtr'))
        ec.parameters(1)=round(contractTriggers.ThMAtr(ci),2);
       end
       if (strcmp(ec.thresholdType.char,'StpLmtDiffPerc'))
        ec.parameters(1)=round(contractTriggers.ThStpLmtDiffPerc(ci),2);
       end
       if (strcmp(ec.thresholdType.char,'StpLoss'))
        ec.parameters(1)=round(contractTriggers.ThEntryStp(ci)-contractTriggers.ThTrailAmt(ci),2);
       end
       if (strcmp(ec.thresholdType.char,'VolRate'))
        ec.parameters(1)=round(contractTriggers.ThVolRate(ci),0);
        %second parameter must exist already in the tmeplate!
        
       end

end