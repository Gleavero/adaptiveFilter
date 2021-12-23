function [out1,out2]=filt(noise,additiveMix, discreteSize,rI,pI, ha1, ha2)

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

x = NaN(size(additiveMix));
w0 = zeros(L,1)';
W = w0;

lenMix = length(additiveMix);
for i=rI:lenMix-discreteSize 
    %Объект адаптивного фильтра
    ha = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
    [~,x_tmp] = ha(noise(1,i:i+discreteSize),additiveMix(1,i:i+discreteSize));
    x(i:i+discreteSize) = x_tmp;
end
for i=pI:lenMix-discreteSize
    %Объект адаптивного фильтра
    ha = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
        [~,x_tmp] = ha(noise(1,i:i+discreteSize),additiveMix(1,i:i+discreteSize));
        x1(i:i+discreteSize) = x_tmp;
end
out1=x;
out2=x1;
end