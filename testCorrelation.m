clear all;
t = 1 : 500;
signal = generateImpulse(t,100);
normSignal = signal/norm(signal);
Fragment = normSignal(200:300);

gaus = wgn(1,length(t),-20);
noise = signal+gaus;

mix = signal+gaus;

normMix = mix/norm(mix);


[xCorr, lags] = xcorr(normMix,Fragment);
[~,I] = max(abs(xCorr));
startFrag = lags(I);
Trial = NaN(size(mix));
size = startFrag+1:startFrag+length(Fragment);
Trial(size) = Fragment;

figure
subplot(2,1,1); plot(t,mix,t,Trial); 
subplot(2,1,2); plot(lags/100,xCorr); axis([-5 5 -1 1]);