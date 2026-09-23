Fs = 1;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = numel(mainticks{1}.params.TimeTables.Minute5d.Close);             % Length of signal
%t = (0:L-1)*T;        % Time vector


fmultiplier=1;

f =1000* Fs*(1:(1/fmultiplier):(L/2))/L;
sf=size(f)

Y=fft(mainticks{1}.params.TimeTables.Minute5d.Close,L*fmultiplier);

sY=size(Y)

P2 = abs(Y/L);
P1 = P2(2:(1/fmultiplier):L/2+1);

sP=size(P1)

plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (sample/minute)')
ylabel('|P1(f)|')
