function symbols=YahooOptioncontracts2IBOptionsSymbols(symbol,symbols);
ibsymbol=pad(symbol,6);
for i=1:numel(symbols)
  symbols{i}=replace(symbols{i},symbol,ibsymbol);  
    
end
end