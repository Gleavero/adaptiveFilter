function out=filt(noise,additiveMix, discreteSize,I, ha)
%Длина адаптивнго фильтра
L = ha.Length;
%Коэффициент забывания
lam = ha.ForgettingFactor;
%Начальный вектор коэффициентов
w0 = zeros(L,1)';
W = w0;
%Начальные значения матрицы P
P0 = ha.InitialInverseCovariance;
% Цикл адаптации
start=I;
final=I+discreteSize;

lock = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W,'LockCoefficients', true);
[~,x_tmp] = lock(noise(1,1:start-1),additiveMix(1,1:start-1));
x(1:start-1)= x_tmp;

[~,x_tmp] = ha(noise(1,start:final),additiveMix(1,start:final));
W = ha.Coefficients;
x(start:final) = x_tmp;

lock = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W,'LockCoefficients', true);
[~,x_tmp] = lock(noise(1,final+1:length(additiveMix)),additiveMix(1,final+1:length(additiveMix)));
x(final+1:length(additiveMix))= x_tmp;
% iterations = length(additiveMix)/discreteSize;
% for i=1:iterations
%     start = discreteSize*(i-1)+1;
%     final = discreteSize*i;
%     if i == I 
%         [~,x_tmp] = ha(noise(1,start:final),additiveMix(1,start:final));
%         W = ha.Coefficients;
%         x(start:final) = x_tmp;
%     else
%         lock = dsp.RLSFilter('Length',L,'ForgettingFactor',lam,'InitialInverseCovariance',P0,'InitialCoefficients',W,'LockCoefficients', true);
%         [~,x_tmp] = lock(noise(1,start:final),additiveMix(1,start:final));
%         x(start:final) = x_tmp;
%     end
% end
out=x;
end