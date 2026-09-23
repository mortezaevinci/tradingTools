function [levels] = indicators_levels_pp(func_,close,high,low,style,power,idbase,namebase,alpha)
try
levels.color={};
levels.values=[];
levels.dir=[];
levels.style={};
levels.width=[];
levels.power=[];
levels.id=[];
levels.name={};

levels.values=func_(close,high,low);
levels.color={[0 0.8 0 alpha],[0 0.8 0 alpha],[0 0.8 0 alpha],[0 0.8 0 alpha],[1 0 1 alpha],[1 0 0 alpha],[1 0 0 alpha],[1 0 0 alpha],[1 0 0 alpha]};
levels.style={style,style,style,style,style,style,style,style,style};
levels.dir=[0 0 0 0 0 0 0 0 0];
levels.width=[power power power power power power power power power ];
levels.power=[power power power power power power power power power ];
levels.id=(uint16(idbase)*0x0100)+uint16(0:8);
levels.name={[namebase 'S4'],[namebase 'S3'],[namebase 'S2'],[namebase 'S1'],[namebase 'PP'],[namebase 'R1'],[namebase 'R2'],[namebase 'R3'],[namebase 'R4'],};
catch exception
   dumpReport('error.log', exception) 
      
end
end

