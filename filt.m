function [out1,out2,diff]=filt(noise,additiveMix, discreteSize,rI,pI, ha1, ha2)

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
diffI = pI-rI;
lenMix = length(additiveMix);
for i=rI:lenMix-(discreteSize+diffI)
    [~,x_tmp1] = ha1(noise(1,i:i+discreteSize),additiveMix(1,i:i+discreteSize));
    x(i:i+discreteSize) = x_tmp1;
    [~,x_tmp2] = ha2(noise(1,(i+diffI):(i+diffI)+discreteSize),additiveMix(1,(i+diffI):(i+diffI)+discreteSize));
     x1(i:i+discreteSize) = x_tmp2;
     normX1 = x_tmp1./norm(x_tmp1);
     normX2 = x_tmp2./norm(x_tmp2);
     difference(i) = mean(normX1-normX2);
end
% for i=pI:lenMix-discreteSize
%     %Объект адаптивного фильтра
%     ha = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
%         
% end
out1=x;
out2=x1;
diff=difference;
end