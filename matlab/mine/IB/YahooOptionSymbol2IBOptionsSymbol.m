function symbols=YahooOptionSymbol2IBOptionsSymbol(symbol,symbols);
ibsymbol=pad(symbol,6);

  symbols=replace(symbols,symbol,ibsymbol);  

end