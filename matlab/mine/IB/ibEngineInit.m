function Engine=EngineInit(apipath)
Engine.assemblies.IBApi = NET.addAssembly(([apipath 'CSharpAPI.dll']));
Engine.assemblies.IBWrapper = NET.addAssembly(([apipath 'IBBackEnd.dll']));
Engine.assemblies.IBCD = NET.addAssembly(([apipath 'IBControlDefinition.dll']));
Engine.assemblies.IO = NET.addAssembly('System.IO');
Engine.assemblies.Serialization = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;
import MHA.IBControlDefinition.*;
import MHA.IBControlDefinition.Tools.*;
import MHA.IBControlDefinition.Tools.Contracts.*;
import IBApi.*;

%% constants

Engine.currentTicker.historicaldata = 1;
Engine.currentTicker.realtimebars = 1;
Engine.currentTicker.scanner = 1;

%% init

Engine.signal=EReaderMonitorSignal;
Engine.ibClient=IBClient(Engine.signal);
Engine.ibWrapper=IBWrapper(Engine.ibClient,Engine.signal);

end