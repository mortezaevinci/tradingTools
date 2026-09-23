function isopen=ismarketopen(date0)

isopen=isempty(nyseclosures(date0,date0)) & isbusday(date0);

end