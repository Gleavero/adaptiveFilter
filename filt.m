function [out1,out2,diff,filt]=filt(noise,additiveMix, discreteSize,rI,pI,ha1,ha2)

%Длина адаптивнго фильтра
L = discreteSize;
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
filts = NaN(size(additiveMix));
w0 = zeros(L,1)';
W = w0;
diffI = pI-rI;
lenMix = length(additiveMix);
% % % Every iteration learning with detect of change process
for i=rI:lenMix-(3*discreteSize+diffI)
    
%     ha1 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
%     ha2 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',w0);
    
    [~,x_tmp1] = ha1(noise(1,i:i+discreteSize),additiveMix(1,i:i+discreteSize));
    W1 = ha1.Coefficients;
    [~,x_tmp2] = ha2(noise(1,(i+diffI):(i+diffI)+discreteSize),additiveMix(1,(i+diffI):(i+diffI)+discreteSize));
    W2 = ha2.Coefficients;
    
    haU1 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W1,'LockCoefficients', true);
    haU2 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W2,'LockCoefficients', true);
    [~,test1] = haU1(noise(1,i+discreteSize:i+2*discreteSize),additiveMix(1,i+discreteSize:i+2*discreteSize));
    [~,test2] = haU2(noise(1,(i+diffI+2*discreteSize):(i+diffI)+3*discreteSize),additiveMix(1,(i+diffI+2*discreteSize):(i+diffI)+3*discreteSize));
    
%     haU1 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W1,'LockCoefficients', true);
%     haU2 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W2,'LockCoefficients', true);
%     [~,test1] = haU1(noise(1,(i+diffI+discreteSize+1):(i+diffI)+2*discreteSize),additiveMix(1,(i+diffI+discreteSize+1):(i+diffI)+2*discreteSize));
%     [~,test2] = haU2(noise(1,(i+diffI+discreteSize+1):(i+diffI)+2*discreteSize),additiveMix(1,(i+diffI+discreteSize+1):(i+diffI)+2*discreteSize));
    
    x(i:i+discreteSize) = x_tmp1;
    x1((i+diffI):(i+diffI)+discreteSize) = x_tmp2;
    
    filts(i) = mean(W1-W2).^2;
    
     normX1 = test1./norm(test1);
     normX2 = test2./norm(test2);
     difference(i) = mean((normX1-normX2).^2);
end
% % % 
% % % 
% for i=rI:lenMix-(discreteSize+diffI)
%     [~,x_tmp1] = ha1(noise(1,i:i+discreteSize),additiveMix(1,i:i+discreteSize));
%     [~,x_tmp2] = ha2(noise(1,(i+diffI):(i+diffI)+discreteSize),additiveMix(1,(i+diffI):(i+diffI)+discreteSize));
%     x(i:i+discreteSize) = x_tmp1;
%     x1((i+diffI):(i+diffI)+discreteSize) = x_tmp2;
%      normX1 = x_tmp1./norm(x_tmp1);
%      normX2 = x_tmp2./norm(x_tmp2);
%      difference(i) = mean((normX1-normX2).^2);
% end
% % % 
% Learning algorithm
% % % 
% [~,x_tmp1] = ha1(noise(1,rI:rI+discreteSize),additiveMix(1,rI:rI+discreteSize));
% [~,x_tmp2] = ha2(noise(1,pI:pI+discreteSize),additiveMix(1,pI:pI+discreteSize));
% W1 = ha1.Coefficients;
% W2 = ha2.Coefficients;
%     haU1 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W1,'LockCoefficients', true);
%     haU2 = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W2,'LockCoefficients', true);
%     x(rI:rI+discreteSize) = x_tmp1;
%     x1(pI:pI+discreteSize) = x_tmp2;
%     [~,x(rI+discreteSize:length(noise))] = haU1(noise(1,rI+discreteSize:length(noise)),additiveMix(1,rI+discreteSize:length(noise)));
%     [~,x1(pI+discreteSize:length(noise))] = haU2(noise(1,pI+discreteSize:length(noise)),additiveMix(1,pI+discreteSize:length(noise)));
% 
%      normX1 = x./norm(x);
%      normX2 = x1./norm(x1);
%      difference = movmean((normX1-normX2).^2,32);
filt = filts;
out1=x;
out2=x1;
diff=difference;
end