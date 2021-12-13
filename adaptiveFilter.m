clear all;

t = 1:1000;
discreteSize = 10;
rI = 220;
pI = 170;
impulse = generateImpulse(t,100);

noise = generateNoise(t);

additiveMix = impulse+noise;

%Длина адаптивнго фильтра
L = 64;
%Коэффициент забывания
lam = 1;
%Оценка дисперсии входного сигнала
sigma = 0.1;
%Начальный вектор коэффициентов
w0 = zeros(L,1)';
W = w0;
W2 = w0;
%Начальные значения матрицы P
P0 = (1/sigma)*eye(L,L);
%Объект адаптивного фильтра 1
ha1 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
%Объект адаптивного фильтра 2
ha2 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);

x = filt(noise,additiveMix,discreteSize,rI,ha1);

x1 = filt(noise,additiveMix,discreteSize,pI,ha2);

figure
subplot(5,1,1); plot(t, impulse); axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
% xline(rI*discreteSize); xline(rI*discreteSize+discreteSize); xline(pI*discreteSize); xline(pI*discreteSize+discreteSize);
xline(rI); xline(rI+discreteSize); xline(pI); xline(pI+discreteSize);
xlabel('Time'); ylabel('Signal');
subplot(5,1,2); plot(t, noise); axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Noise');
subplot(5,1,3); plot(t, additiveMix); axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Signal+Noise');
subplot(5,1,4); plot(t, x); axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Adaptive Filter 1');
subplot(5,1,5); plot(t, x1); axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Adaptive Filter 2');

normX = x.^2;
normX1 = x1.^2;
meanX = smoothMean(normX(120:1000)+normX1(120:1000));
meanX1 = smoothMean(normX1);
mean = mean(meanX);
D = var(meanX);
figure
subplot(4,1,1); plot(t(120:1000),meanX);
% subplot(4,1,2); plot(t,meanX1);
% subplot(4,1,3); plot (t, meanX-meanX1);
% subplot(4,1,4); spectrogram(meanX-meanX1);
Enorm = sum(normX);
Enorm1 = sum(normX1);
E = sum(meanX-meanX1);
Eimp = sum(impulse);