FrameSize = 200;
impulseLength = 120;
t = 1:2000;
% Генерация импульса
impulse = generateImpulse(t,200,100);
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
[~,x] = ha1(noise, additiveMix);

plot(t,x);