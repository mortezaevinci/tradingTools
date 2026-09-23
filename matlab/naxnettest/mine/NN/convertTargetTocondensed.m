function t=convertTargetTocondensed(T)
    t=zeros(size(T(2,:)));
    t(T(1,:)>0.5)=-T(1,T(1,:)>0.5);
    t(T(3,:)>0.5)=+T(3,T(3,:)>0.5);
end