date0='2020-12-18';
sym='KERN';
fn=['Z:\My files\Project trading\traderdata\data_other\IB\' sym '\' sym ' ' 'minute' ' ' date0 '.mat'];

load(fn);

ttm=table2timetable(tm);

cndlv(ttm);