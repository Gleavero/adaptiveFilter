clear all; clc;
% Временной диапазон
t = 1:2400;
% Частота дискретизации (пока условно ширина "щупов")
discreteSize =8;
% Начальное положение рабочего импульса
rI = 10;
% Начальное положение проверочного импульса
pI =19;
% Генерация импульса
impulse = generateImpulse(t,800,600);
% impulse = 2*sin(2*pi*0.055*t);
% impulse = zeros(size(t));
% Генерация шума
noise = generateNoise(t);
% Смесь импульса с шумом
additiveMix = impulse+noise;
% Доля проникновения импульса на опорный вход
noise = noise+0.2*impulse;
% Настройки RLS-фильтра
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
%Объект адаптивного фильтра RLS
ha1 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
ha2 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
% Объекты адаптивного фильтра NLMS
% ha1 = dsp.LMSFilter('Method', 'Normalized LMS', 'Length', L, 'StepSize',0.2, 'LeakageFactor', 1, 'InitialConditions', 1e-6);
% ha2 = dsp.LMSFilter('Method', 'Normalized LMS', 'Length', L, 'StepSize',0.2, 'LeakageFactor', 1, 'InitialConditions', 1e-6);

% Основная функция обработки сигнала
[x,x1,difference,filters] = filt(noise,additiveMix,discreteSize,rI,pI,ha1,ha2);
% NLMS
% [x,x1,difference] = LMSfilt(noise',additiveMix',discreteSize,rI,pI,ha1,ha2);
% x = x';
% x1 = x1';
difference = difference';
% Вычисляем разницу между выходами адаптивных фильтров и исходным сигналом
resAF1 = quadroDiff(impulse,x,800,2000);
resAF2 = quadroDiff(impulse,x1,800,2000);

diff = pI-rI;

ha = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
output = NaN(size(t));
WOut = W;
[~,output(600:700)] = ha(noise(600:700),additiveMix(600:700));
WOut = ha.Coefficients;
haOut = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',WOut,'LockCoefficients', true);

[~,output(700:length(t))] = haOut(noise(700:length(t))+0.1*impulse(700:length(t)),additiveMix(700:length(t)));


resOut = quadroDiff(impulse,output,800,2000);

meanDiff = NaN(size(t));
meanDiff(1:length(difference)) = movmean(difference, 64);

figure

subplot(6,1,1); plot(t, impulse); 
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Signal');

subplot(6,1,2); plot(t, noise);
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Noise');

subplot(6,1,3); plot(t, additiveMix); 
axis([0 length(additiveMix) min(additiveMix) max(additiveMix)]);
xlabel('Time'); ylabel('Signal+Noise');

subplot(6,1,4); plot(t, x);
axis([0 length(additiveMix) min(x(500:length(t))) max(x(500:length(t)))]);
xlabel('Time'); ylabel('Adaptive Filter 1'); 

subplot(6,1,5); plot(t, x1); 
axis([0 length(additiveMix) min(x1(500:length(t))) max(x1(500:length(t)))]);
xlabel('Time'); ylabel('Adaptive Filter 2');

subplot(6,1,6); plot(t, output); 
axis([0 length(additiveMix) min(output(700:length(t))) max(output(700:length(t)))]);
xlabel('Time'); ylabel('Adapt in pause');
