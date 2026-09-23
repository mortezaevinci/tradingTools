%% libraries

compiledir = 'debug'; %'release', 'debug'

assemblies.systemExtension = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\SystemExtension.dll']);
assemblies.CSharpAPI = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\CSharpAPI.dll']);
assemblies.IBBackEnd = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\IBBackEnd.dll']);
assemblies.ContractDefinition = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\ContractDefinition.dll']);
assemblies.ContractDefinition = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\OrderDefinition.dll']);
assemblies.ContractDefinition = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\TickDefinition.dll']);
assemblies.ContractDefinition = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\IBAccountDefinition.dll']);
assemblies.TradeExtension = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\TradeExtension.dll']);
assemblies.CSharpAPI = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\IBControlDefinition.dll']);
assemblies.IBWrapper = NET.addAssembly(['C:\temp\tradingTools\matlab\mine\bin\' compiledir '\IBWrapper.dll']);

assemblies.System.IO = NET.addAssembly('System.IO');
assemblies.System.Runtime.Serialization = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;
import MHA.IBControlDefinition.*;
import MHA.IBControlDefinition.AuxAccountInfo.*;
import MHA.ContractDefinition.*;
import MHA.ContractDefinition.Tools.*;
import MHA.ContractDefinition.*;
import MHA.OrderDefinition.Tools.*;
import MHA.OrderDefinition.*;
import MHA.IBAccountDefinition.*;
import MHA.TickDefinition.*;
import MHA.ExternalCondition.*;
import System.ObjectExtensions.*;

import IBApi.*;