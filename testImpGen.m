clear all; clc;
t = 1:2400;
% Генерация импульса
impulse = generateImpulse(t,800,600);
% Генерация шума
noise = generateNoise(t);
% Смесь импульса с шумом
additiveMix = impulse+noise;
%Длина адаптивнго фильтра
L = 16;
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

[~,x] = ha1(noise+0.5*impulse, additiveMix);

% Adaptive ustr
% x(1:780) = additiveMix(1:780);
% [~,x(780:800)] = ha1(noise(780:800)+0.5*impulse(780:800), additiveMix(780:800));
% W2 = ha1.Coefficients;
% haU2 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W2,'LockCoefficients', true);
% [~,x(801:2400)] = haU2(noise(801:2400)+0.5*impulse(801:2400), additiveMix(801:2400));

pause = zeros(length(t));

for i =1 : length(t)
    if impulse(i) == 0
        pause(i) = 2;
    end
end
pause (600:630) = 0;
pause(800:830) = 2;
pause(1400:1430) = 0;
figure
subplot(3,1,1); plot(impulse(1:1600));
xlabel('Time'); ylabel('Impulse');
subplot(3,1,2); plot([1:1600], additiveMix(1:1600)); 
xlabel('Time'); ylabel('Additive mix');
subplot(3,1,3); plot(x(1:1600));
xlabel('Time'); ylabel('Output');