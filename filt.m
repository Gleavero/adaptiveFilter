function [out1,out2,diff]=filt(noise,additiveMix, discreteSize,rI,pI)

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
x1 = NaN(size(additiveMix));
w0 = zeros(L,1)';
W = w0;
diffI = pI-rI;
lenMix = length(additiveMix);
for i=rI:lenMix-(3*discreteSize+diffI)
    
    ha1 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
    ha2 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
    
    [~,x_tmp1] = ha1(noise(1,i:i+discreteSize),additiveMix(1,i:i+discreteSize));
    W1 = ha1.Coefficients;
    [~,x_tmp2] = ha2(noise(1,(i+diffI):(i+diffI)+discreteSize),additiveMix(1,(i+diffI):(i+diffI)+discreteSize));
    W2 = ha2.Coefficients;
    
    haU1 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W1,'LockCoefficients', true);
    haU2 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W2,'LockCoefficients', true);
    [~,test1] = haU1(noise(1,(i+diffI+discreteSize):(i+diffI)+2*discreteSize),additiveMix(1,(i+diffI+discreteSize):(i+diffI)+2*discreteSize));
    [~,test2] = haU2(noise(1,(i+diffI+discreteSize):(i+diffI)+2*discreteSize),additiveMix(1,(i+diffI+discreteSize):(i+diffI)+2*discreteSize));
    
    x(i:i+discreteSize) = x_tmp1;
    x1((i+diffI):(i+diffI)+discreteSize) = x_tmp2;
    
     normX1 = test1./norm(test1);
     normX2 = test2./norm(test2);
     difference(i) = mean((normX1-normX2).^2);
end
% for i=rI:lenMix-(discreteSize+diffI)
%     [~,x_tmp1] = ha1(noise(1,i:i+discreteSize),additiveMix(1,i:i+discreteSize));
%     W1 = ha1.Coefficients;
%     [~,x_tmp2] = ha2(noise(1,(i+diffI):(i+diffI)+discreteSize),additiveMix(1,(i+diffI):(i+diffI)+discreteSize));
%     x(i:i+discreteSize) = x_tmp1;
%     x1((i+diffI):(i+diffI)+discreteSize) = x_tmp2;
%      normX1 = x_tmp1./norm(x_tmp1);
%      normX2 = x_tmp2./norm(x_tmp2);
%      difference(i) = mean((normX1-normX2).^2);
% end
out1=x;
out2=x1;
diff=difference;
end