ccnt=1;
contracts_pennies_trade;c{ccnt}=contracts;ccnt=ccnt+1;
contracts_pennies1;c{ccnt}=contracts;ccnt=ccnt+1;
contracts_pennies2;c{ccnt}=contracts;ccnt=ccnt+1;
contracts_pennies3;c{ccnt}=contracts;ccnt=ccnt+1;
contracts_pennies4;c{ccnt}=contracts;ccnt=ccnt+1;
contracts_pennies5;c{ccnt}=contracts;ccnt=ccnt+1;
contracts_pennies6;c{ccnt}=contracts;ccnt=ccnt+1;

contracts={c{1}{:},c{2}{:},c{3}{:},c{4}{:},c{5}{:},c{6}{:},c{7}{:}};
clear c;

contracts_=uniqueContracts(contracts,'FileSymbol');

genContractFileFromContracts('contracts\contracts_penniesm2.m',contracts_);

