function t=convertTargetTocondensed(T)
thresh=0.25;
    t=zeros(size(T(2,:)));
    t(T(1,:)>thresh)=-T(1,T(1,:)>thresh);
    t(T(3,:)>thresh)=+T(3,T(3,:)>thresh);
end