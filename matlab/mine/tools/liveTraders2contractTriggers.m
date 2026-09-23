function contractTriggers=liveTraders2contractTriggers(fn,date0)
fileID = fopen(fn,'r');
Symbol=cell(0);
FileSymbol=cell(0);
cnt=1;
Marked=[];
ThDiffVolMax=[];
ThDiffVolAve=[];
ThVol=[];
ThMaxHigh=[];
ThEntryStp=[];
ThMAtr=[];
ThTrailAmt=[];
ThStpLmtDiffPerc=[];
ThTarget1=[];
ThTarget2=[];
ThTarget=[];
ThEntryLmt=[];
ThVolRate=[];
ThAbsVol=[];

df0=datestr(datetime(date0),'yyyymmdd');
% contractTriggers.(['d' df0])=NewContractTriggersFromContracts(contracts);

startcheck=0;
if (~isempty(fileID))
    while(1)
        try
            if (startcheck==0)
                tline{1}=fgetl(fileID);
                if (contains(tline{1},'Long') || contains(tline{1},'Short'))
                    startcheck=1;
                    try
                        tline{2}=fgetl(fileID);
                        tline{3}=fgetl(fileID);
                        tline{4}=fgetl(fileID);
                    catch
                        
                    end
                else
                    continue;
                end
                
            else
                for i=1:4
                    tline{i} = fgetl(fileID);
                end
            end
            
            %sanity
            if (~isempty(tline{4}) && ~contains(tline{2},'Stop Loss') ...
                    && ~contains(tline{3},'Target'))
                disp('wrong format');
                break;
            end
            % data
            if (contains(tline{1},'Long'))
                da1=split(tline{1},' Long $');
                if (numel(da1)~=2);break;end;
                symbol_=da1{1};
                entry_=str2num(da1{2});
                stop_=str2num(replace(tline{2},'Stop Loss $',''));
                target_=str2num(replace(tline{3},'Target $',''));
                Symbol{cnt,1}=symbol_;
                FileSymbol{cnt,1}=fieldfriendlysymbol(symbol_);
                Marked=[Marked;2];
                ThDiffVolMax=[ThDiffVolMax;0];
                ThDiffVolAve=[ThDiffVolAve;0];
                ThVol=[ThVol;0];
                ThVolRate=[ThVolRate;0];
                ThAbsVol=[ThAbsVol;0];
                ThMaxHigh=[ThMaxHigh;0];
                ThEntryStp=[ThEntryStp;entry_];
                ThMAtr=[ThMAtr;(entry_-stop_)];
                ThTrailAmt=[ThTrailAmt;(entry_-stop_)];
                ThTarget=[ThTarget;target_];
                ThTarget1=[ThTarget1;target_];
                ThTarget2=[ThTarget2;target_];
                ThStpLmtDiffPerc=[ThStpLmtDiffPerc;1.02];
                ThEntryLmt=[ThEntryLmt;entry_*1.02];
                cnt=cnt+1;
            else
                disp('Short orders not supported.');
            end
        catch exception
            break;
        end
    end
end
fclose(fileID);

contractTriggers.(['d' df0])=table(Symbol,FileSymbol,Marked,...
    ThDiffVolMax,ThDiffVolAve,ThVol,ThAbsVol,ThVolRate,...
    ThMaxHigh,ThEntryStp,ThEntryLmt,ThMAtr,ThTrailAmt,...
    ThTarget,ThTarget1,ThTarget2,ThStpLmtDiffPerc);

end

%
% function contractTriggers=liveTraders2contractTriggers(fn)
% fileID = fopen(fn,'r');
% Symbol=cell(0);
% FileSymbol=cell(0);
% cnt=1;
% Marked=[];
% ThDiffVolMax=[];
% ThDiffVolAve=[];
% ThVol=[];
% ThMaxHigh=[];
% ThEntryStp=[];
% ThMAtr=[];
% ThTrailAmt=[];
% ThStpLmtDiffPerc=[];
% ThTarget1=[];
% ThTarget2=[];
% ThTarget=[];
% ThEntryLmt=[];
%
% startcheck=0;
% if (~isempty(fileID))
%     while(1)
%         try
%             if (startcheck==0)
%                 tline{1}=fgetl(fileID);
%                 if (contains(tline{1},'Long') || contains(tline{1},'Short'))
%                     startcheck=1;
%                     try
%                         tline{2}=fgetl(fileID);
%                         tline{3}=fgetl(fileID);
%                         tline{4}=fgetl(fileID);
%                     catch
%
%                     end
%                 else
%                     continue;
%                 end
%
%             else
%                 for i=1:4
%                     tline{i} = fgetl(fileID);
%                 end
%             end
%
%             %sanity
%             if (~isempty(tline{4}) && ~contains(tline{2},'Stop Loss') ...
%                     && ~contains(tline{3},'Target'))
%                 disp('wrong format');
%                 break;
%             end
%             % data
%             if (contains(tline{1},'Long'))
%                 da1=split(tline{1},' Long $');
%                 if (numel(da1)~=2);break;end;
%                 symbol_=da1{1};
%                 entry_=str2num(da1{2});
%                 stop_=str2num(replace(tline{2},'Stop Loss $',''));
%                 target_=str2num(replace(tline{3},'Target $',''));
%                 Symbol{cnt,1}=symbol_;
%                 FileSymbol{cnt,1}=fieldfriendlysymbol(symbol_);
%                 Marked=[Marked;2];
%                 ThDiffVolMax=[ThDiffVolMax;0];
%                 ThDiffVolAve=[ThDiffVolAve;0];
%                 ThVol=[ThVol;0];
%                 ThMaxHigh=[ThMaxHigh;0];
%                 ThEntryStp=[ThEntryStp;entry_];
%                 ThMAtr=[ThMAtr;(entry_-stop_)];
%                 ThTrailAmt=[ThTrailAmt;0];
%                 ThTarget=[ThTarget;target_];
%                 ThTarget1=[ThTarget1;target_];
%                 ThTarget2=[ThTarget2;target_];
%                 ThStpLmtDiffPerc=[ThStpLmtDiffPerc;1.02];
%                 ThEntryLmt=[ThEntryLmt;entry_*1.02];
%                 cnt=cnt+1;
%             else
%                 disp('Short orders not supported.');
%             end
%         catch exception
%             break;
%         end
%     end
% end
% fclose(fileID);
%
% contractTriggers=table(Symbol,FileSymbol,Marked,...
%     ThDiffVolMax,ThDiffVolAve,ThVol,...
%     ThMaxHigh,ThEntryStp,ThEntryLmt,ThMAtr,ThTrailAmt,...
%     ThTarget,ThTarget1,ThTarget2,ThStpLmtDiffPerc);
%
% end