function indicatorsProfile=fixpconditionbased(indicatorsProfile,excludeindexes)

indicatorsProfile.mean(excludeindexes)=0;
indicatorsProfile.range(excludeindexes)=0;

pfailedind=find(isnan(indicatorsProfile.mean) | isnan(indicatorsProfile.range) | isinf(indicatorsProfile.mean) | isinf(indicatorsProfile.range));

indicatorsProfile.mean(pfailedind)=0;
indicatorsProfile.range(pfailedind)=0;


end 