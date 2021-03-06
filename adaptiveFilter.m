clear all;
% Временной диапазон
t = 1:2000;
% Частота дискретизации (пока условно ширина "щупов")
discreteSize = 32;
% Начальное положение рабочего импульса
rI = 10;
% Начальное положение проверочного импульса
% pI = rI+discreteSize*2;
pI = 70;
% Генерация импульса
impulse = generateImpulse(t,400,100);
% Генерация шума
noise = generateNoise(t);
% Смесь импульса с шумом
additiveMix = impulse+noise;
%Длина адаптивнго фильтра
L = 32;
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

[x,x1,difference] = filt(noise,additiveMix,discreteSize,rI,pI);

% normX = x(pI+discreteSize:length(t))./norm(x(pI+discreteSize:length(t)));
% normX1 = x1(pI+discreteSize:length(t))./norm(x1(pI+discreteSize:length(t)));

diff = pI-rI;

% x = movmean(x,5);
% x1 = movmean(x1,5);

% x = x.^2;
% x1 = x1.^2;

% difference = (normX-normX1).^2;
meanDiff = NaN(size(t));
meanDiff(1:length(difference)) = movmean(difference, 64);

figure

subplot(6,1,1); plot(1:length(t),meanDiff); 
% axis([1 length(meanDiff) 0 0.01]);
xlabel('Time');

subplot(6,1,2); plot(t, impulse, ...
    [rI rI+discreteSize; rI rI+discreteSize], [min(additiveMix) min(additiveMix);max(additiveMix) max(additiveMix)],'r--', ...
    [pI pI+discreteSize; pI pI+discreteSize],[min(additiveMix) min(additiveMix);max(additiveMix) max(additiveMix)],'g--', ...
    [pI+discreteSize+1 pI+3*discreteSize; pI+discreteSize+1 pI+3*discreteSize],[min(additiveMix) min(additiveMix);max(additiveMix) max(additiveMix)],'b--'); 
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Signal');

subplot(6,1,3); plot(t, noise);
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Noise');

subplot(6,1,4); plot(t, additiveMix); 
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Signal+Noise');

subplot(6,1,5); plot(t, x);
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Adaptive Filter 1'); 

subplot(6,1,6); plot(t, x1); 
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Adaptive Filter 2');

