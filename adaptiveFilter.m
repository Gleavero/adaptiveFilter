clear all;

t = 1:1000;
discreteSize = 100;

impulse = generateImpulse(t)';

noise = generateNoise(t);

%Длина адаптивнго фильтра
L = 32;
%Коэффициент забывания
lam = 1;
%Оценка дисперсии входного сигнала
sigma = 0.1;
%Начальный вектор коэффициентов
w0 = zeros(L,1)';
W = w0;
%Начальные значения матрицы P
P0 = (1/sigma)*eye(L,L);
%Начальное состояние фильтра
Zi = zeros(L-1,1);
%Объект адаптивного фильтра 1
ha = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
x_tmp = zeros(1,discreteSize);
for i=1:size(t)/discreteSize
    if mod(i,2) == 0 
        lock = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W,'LockCoefficients', true);
        [y,x_tmp] = lock(noise());
    else
      [y,x] = ha(noise,impulse+noise);
      W = ha.Coefficients;
    end
end

figure
subplot(4,1,1); plot(t, impulse);
xlabel('Time'); ylabel('Signal');
subplot(4,1,2); plot(t, noise);
xlabel('Time'); ylabel('Noise');
subplot(4,1,3); plot(t, noise+impulse);
xlabel('Time'); ylabel('Signal+Noise');
subplot(4,1,4); plot(t, x);
xlabel('Time'); ylabel('Adaptive Filter 1');