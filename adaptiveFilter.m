clear all;
% Временной диапазон
t = 1:2400;
% Частота дискретизации (пока условно ширина "щупов")
discreteSize =8;
% Начальное положение рабочего импульса
rI = 10;
% Начальное положение проверочного импульса
% pI = rI+discreteSize*2;
pI =18;
% Генерация импульса
impulse = generateImpulse(t,800,200);
% Генерация шума
noise = generateNoise(t);
% nfilt = fir1(31,0.5);
% fNoise = filter(nfilt,1,noise);
% Смесь импульса с шумом
additiveMix = impulse+noise;

noise = noise+0*impulse;
%Длина адаптивнго фильтра
L = discreteSize;
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
[x,x1,difference,filters] = filt(noise,additiveMix,discreteSize,rI,pI,ha1,ha2);

normX = x(800:2000)/norm(x(800:2000));
normX1 = x1(800:2000)/norm(x1(800:2000));
normImpulse = impulse(800:2000)/norm(impulse(800:2000));
resAF1 = NaN(size(t));
resAF2 = NaN(size(t));
resOut = NaN(size(t));

resAF1(800:2000) = (normX-normImpulse).^2;
resAF2(800:2000) = (normX1-normImpulse).^2;

diff = pI-rI;

ha = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
output = NaN(size(t));
WOut = W;
[~,output(600:700)] = ha(noise(600:700)+0.1*impulse(600:700),additiveMix(600:700));
WOut = ha.Coefficients;
% 
haOut = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',WOut,'LockCoefficients', true);
% 
[~,output(700:length(t))] = haOut(noise(700:length(t))+0.1*impulse(700:length(t)),additiveMix(700:length(t)));


normOut = output(800:2000)/norm(output(800:2000));
resOut(800:2000) = (normOut-normImpulse).^2;

% for i=1:length(difference)
%     if difference(i)<0.007
%         
%     end
% end

% x = movmean(x,5);
% x1 = movmean(x1,5);

% x = x.^2;
% x1 = x1.^2;

% difference = (normX-normX1).^2;
meanDiff = NaN(size(t));
meanDiff(1:length(difference)) = movmean(difference, 64);

figure

subplot(6,1,1); plot(t,meanDiff); 
axis([0 length(additiveMix) min(meanDiff) max(meanDiff)]);
xlabel('Time'); ylabel('Diff AF1 and AF2');

subplot(6,1,2); plot(t, impulse, ...
    [rI rI+discreteSize; rI rI+discreteSize], [min(additiveMix) min(additiveMix);max(additiveMix) max(additiveMix)],'r--', ...
    [pI pI+discreteSize; pI pI+discreteSize],[min(additiveMix) min(additiveMix);max(additiveMix) max(additiveMix)],'g--');
%     [pI+discreteSize+1 pI+3*discreteSize; pI+discreteSize+1 pI+3*discreteSize],[min(additiveMix) min(additiveMix);max(additiveMix) max(additiveMix)],'b--'); 
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Signal');

subplot(6,1,3); plot(t, noise);
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Noise');

subplot(6,1,4); plot(t, additiveMix); 
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Signal+Noise');

subplot(6,1,5); plot(t, x);
axis([0 length(additiveMix) min(x(500:length(t))) max(x(500:length(t)))]);
xlabel('Time'); ylabel('Adaptive Filter 1'); 

subplot(6,1,6); plot(t, x1); 
axis([0 length(additiveMix) min(x1(500:length(t))) max(x1(500:length(t)))]);
xlabel('Time'); ylabel('Adaptive Filter 2');

figure
subplot (5,1,1); plot(t,filters);
xlabel('Time'); ylabel('Filter weigths differences');
subplot (5,1,2); plot(t,resAF1);
axis([0 length(resAF2) min(resAF2) max(resAF2)]);
xlabel('Time'); ylabel('Difference between AF1 and Impulse');
subplot (5,1,3); plot(t,resAF2);
axis([0 length(resAF2) min(resAF2) max(resAF2)]);
xlabel('Time'); ylabel('Difference between AF2 and Impulse');
subplot (5,1,4); plot(t,resOut);
axis([0 length(resAF2) min(resAF2) max(resAF2)]);
xlabel('Time'); ylabel('Difference between Output and Impulse');
subplot (5,1,5); plot(t,output);
axis([0 length(output) min(output(800:length(output))) max(output(800:length(output)))]);
xlabel('Time'); ylabel('Output');
