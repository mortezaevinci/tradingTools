function loadIbLibraries()
try
    %% libraries

assemblies.IBApi = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\release\CSharpAPI.dll'));
assemblies.IBBackEnd = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\release\IBBackEnd.dll'));
assemblies.IBCD = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\release\IBControlDefinition.dll'));

assemblies.System.IO = NET.addAssembly('System.IO');
assemblies.System.Runtime.Serialization = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;
import MHA.IBControlDefinition.*;
import MHA.IBControlDefinition.AuxAccountInfo.*;
import MHA.IBControlDefinition.Tools.*;
import MHA.IBControlDefinition.Tools.Contracts.*;
import MHA.IBControlDefinition.Tools.Orders.*;
import MHA.IBControlDefinition.Tools.Conditions.*;
import IBApi.*;
catch e
    error(e.message);
end